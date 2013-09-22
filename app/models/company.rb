class Feedzirra::Parser::Atom
  element 'cik', as: 'cik'
  element 'conformed-name', as: 'conformed_name'
end


class Company < ActiveRecord::Base
  has_many :filings, dependent: :destroy

  validates :name, presence: true
  validates :symbol, presence: true
  validates :cik, presence: true

  def self.find_sec(symbol)
    symbol.downcase!

    # fetch company description and the links to all the filings description pages
    feed = Feedzirra::Feed.fetch_and_parse("http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=#{symbol}&type=10-Q&count=100&output=atom")
    return nil if feed.nil?

    company = Company.where(cik: feed.cik).first
    if company.nil?
      company = Company.create(name: feed.conformed_name, symbol: symbol, cik: feed.cik)
    end

    Filing.transaction do
      feed.entries.each do |entry|
        category = entry.categories[0]
        if category == '10-Q'
          company.filings.create(category: category,
                                 date: entry.updated,
                                 sec_link: entry.url)
        end
      end
    end

    # fetch the pages that describe each filing
    urls = company.filings.pluck(:sec_link)
    html_responses = {}
    Curl::Multi.get(urls) do |response|
      html_responses[response.url] = response.body_str
    end

    # from each filing description page, get the links to the XBRL files
    # and then download all the XBRL files
    m = Curl::Multi.new
    xbrl_instance_bodies = Hash.new do |hash, key| hash[key] = "" end
    xbrl_taxomony_bodies = Hash.new do |hash, key| hash[key] = "" end
    company.filings.each do |filing|
      html_doc = Nokogiri::HTML(html_responses[filing.sec_link])
      instance_doc_link = nil
      taxomony_doc_link = nil

      html_doc.css('a').each do |link_element|
        href = link_element[:href]
        if href =~ /\d+\.xml$/
          instance_doc_link = href
        elsif href =~ /\.xsd$/
          taxomony_doc_link = href
        end
      end

      if instance_doc_link
        c = Curl::Easy.new("http://www.sec.gov#{instance_doc_link}") do |easy|
          easy.on_body do |data|
            xbrl_instance_bodies[filing.id] << data
            data.size
          end
        end
        m.add(c)
      end

      if taxomony_doc_link
        c = Curl::Easy.new("http://www.sec.gov#{taxomony_doc_link}") do |easy|
          easy.on_body do |data|
            xbrl_taxomony_bodies[filing.id] << data
            data.size
          end
        end
        m.add(c)
      end
    end
    m.perform

    # parse XBRL using xbrlware
    xbrl_instances = {}
    Filing.transaction do
      company.filings.each do |filing|
        next if xbrl_instance_bodies[filing.id].blank?
        xbrl_ins = Xbrlware.ins(xbrl_instance_bodies[filing.id], xbrl_taxomony_bodies[filing.id])

        filing.details ||= Hash.new do |hash, key| hash[key] = [] end
        xbrl_ins.item_all.each do |item|
          name = item.name
          period = item.context.period.value
          value = item.value
          next if value.nil? or (value[0] == '<' and value[-1] == '>')
          value = value.to_f if value =~ /^-?\d+(\.\d+)?$/
          period = [period['start_date'], period['end_date']] if period.class == Hash

          filing.details[name] << {period: period, value: value}
        end

        filing.save
      end
    end

    return company
  end
end

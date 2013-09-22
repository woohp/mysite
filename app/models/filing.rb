class Filing < ActiveRecord::Base
  class JSONColumn
    def self.dump(obj)
      obj ? JSON.dump(obj) : nil
    end

    def self.load(json)
      json.nil? ? nil : JSON.load(json)
    end
  end

  serialize :details, JSONColumn

  belongs_to :company

  validates :company_id, presence: true
  validates :category, presence: true
  validates :date, presence: true
end

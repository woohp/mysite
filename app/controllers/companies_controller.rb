class CompaniesController < ApplicationController
  respond_to :html, :json

  def index
    respond_with @companies = Company.all
  end

  def show
    company = Company.find(params[:id])
    
    h = company.attributes
    h['filings'] = company.filings.select('id, category, date')
    respond_with h
  end
end

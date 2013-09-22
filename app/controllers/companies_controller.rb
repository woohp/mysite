class CompaniesController < ApplicationController
  respond_to :html, :json

  def index
    respond_with @companies = Company.all
  end

  def show
    respond_with(@company = Company.includes(:filings).find(params[:id]), include: {filings: { only: [:category, :date]}})
  end
end

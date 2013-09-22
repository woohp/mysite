class FilingsController < ApplicationController
  respond_to :html, :json

  def show
    respond_with(filing = Filing.find(params[:id]), include: :company)
  end
end

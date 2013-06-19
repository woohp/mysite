class SessionsController < ApplicationController
  respond_to :json

  def create
    if user = login(params[:username], params[:password])
      respond_with user
    else
      head :unprocessable_entity
    end
  end

  def destroy
    logout
    head :no_content
  end
end

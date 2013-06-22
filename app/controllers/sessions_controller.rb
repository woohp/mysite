class SessionsController < ApplicationController
  respond_to :json

  def create
    respond_with current_user and return if current_user and current_user.username == params[:username]

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

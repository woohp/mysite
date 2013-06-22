class UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.where(id: params[:id]).first
  end

  def current
    if current_user
      respond_with current_user
    else
      head :not_acceptable
    end
  end

  def create
    user = User.create(username: params[:username],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    auto_login(user) if user.id?

    respond_with user
  end

  def update
    respond_with nil
#    respond_with User.upda
  end
end

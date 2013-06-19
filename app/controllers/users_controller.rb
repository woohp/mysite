class UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.where(id: params[:id]).first
  end

  def create
    respond_with User.create(username: params[:username],
                             password: params[:password],
                             password_confirmation: params[:password_confirmation])
  end

  def update
    respond_with nil
#    respond_with User.upda
  end
end

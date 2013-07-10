class UtilsController < ApplicationController
  respond_to :json

  def secure_random
    respond_with SecureRandom::urlsafe_base64
  end
end

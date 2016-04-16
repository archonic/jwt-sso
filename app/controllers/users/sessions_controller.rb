class Users::SessionsController < Devise::SessionsController
require 'jwt'
  # POST /users/sign_in
  def create
    super
  end
end

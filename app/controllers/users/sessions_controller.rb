class Users::SessionsController < Devise::SessionsController
  require 'jwt'

  def new
    session[:return_to] = params[:return_to]
    session[:env] = params[:env]
    super
  end
end

# Using JWT from Ruby is straight forward. The below example expects you to have `jwt`
# in your Gemfile, you can read more about that gem at https://github.com/jwt/ruby-jwt.
require 'securerandom' unless defined?(SecureRandom)

class ItglueSessionController < ApplicationController
  # Configuration
  ITGLUE_SHARED_SECRET = ENV["ITGLUE_SHARED_SECRET"]
  ITGLUE_SUBDOMAIN     = 'deversus'

  def create
    puts "PARAMS ENV IS #{params[:env]}"
    # session[:env] ||= params[:env]
    # puts "SESSION ENV IS #{session[:env]}"

    default_return =  if params[:env] == 'dev'
                        "http://#{ITGLUE_SUBDOMAIN}.itglue.localhost:3000"
                      elsif params[:env] == 'qa'
                        'https://fm.qa.itglue.com'
                      else
                        "https://#{ITGLUE_SUBDOMAIN}.staging.itglue.com"
                      end

    params[:return_to] = default_return
    params[:return_to] = nil if params[:return_to] == '/itglue_signin' # avoid redirect loop
    user_signed_in? ? sign_into_itglue(current_user) : redirect_to(new_user_session_path(return_to: '/itglue_signin', env: params[:env]))
  end

  private

  def sign_into_itglue(user)
    iat = Time.now.to_i
    jti = "#{iat}/#{SecureRandom.hex(18)}"

    payload = JWT.encode({
      :iat          => iat,         # Seconds since epoch, determine when this token is stale
      :jti          => jti,         # Unique token id, helps prevent replay attacks
      :external_id  => user.id,     # Email can change, this is a unique identifier
      :email        => user.email
    }, ITGLUE_SHARED_SECRET)

    redirect_to itglue_sso_url(payload)
  end

  def itglue_sso_url(payload)
    puts "PARAMS ENV IS #{params[:env]}"
    puts "SESSION ENV IS #{session[:env]}"
    url = session[:env] == 'dev' ? "http://#{ITGLUE_SUBDOMAIN}.itglue.localhost:3000/access/jwt?jwt=#{payload}" : "https://#{ITGLUE_SUBDOMAIN}.staging.itglue.com/access/jwt?jwt=#{payload}"
    url << "&return_to=#{URI.encode(params[:return_to], URI::PATTERN::RESERVED)}" if params[:return_to].present?
    url
  end
end

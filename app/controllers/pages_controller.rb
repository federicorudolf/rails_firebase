require 'net/http'
require 'uri'
require 'json'

class PagesController < ApplicationController
  before_action :set_user_data, only: %i[signup login]

  def index
  end

  def signup
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{ Rails.application.credentials.firebase_api_key }")
    if (@email != nil) 
      response = Net::HTTP.post_form(uri, 'email': @email, 'password': @password)
      data = JSON.parse(response.body)
      session[:user_id] = data['localId']
      session[:data] = data
      redirect_to home_path, notice: 'Signed up successfully' if response.is_a?(Net::HTTPSuccess)
    end
  end

  def home
  end

  def login
  end

  def logout
    session.clear
    redirect_to root_path, notice: 'Logged out successfully'
  end

  private

  def set_user_data
    @email = params[:email]
    @password = params[:password]
  end
end

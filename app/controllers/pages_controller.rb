require 'net/http'
require 'uri'
require 'json'

class PagesController < ApplicationController
  before_action :set_user_data, only: %i[signup login]
  before_action :authenticate_user, except: %i[signup login index]

  def index
  end

  def signup
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{ Rails.application.credentials.firebase_api_key }")
    response = Net::HTTP.post_form(uri, 'email': @email, 'password': @password)
    data = JSON.parse(response.body)
    session[:user_id] = data['localId']
    session[:data] = data
    redirect_to home_path, notice: 'Signed up successfully' if response.is_a?(Net::HTTPSuccess)
  end

  def home
  end

  def login
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{ Rails.application.credentials.firebase_api_key }")
    response = Net::HTTP.post_form(uri, 'email': @email, 'password': @password)

    data = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      session[:user_id] = data['localId']
      session[:data] = data
      redirect_to home_path, notice: 'Logged in successfully'
    end
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

  def authenticate_user
    redirect_to root_path, notice: 'Authentication failed, you must be logged in' unless current_user
  end
end

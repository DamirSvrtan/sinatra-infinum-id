require 'sinatra'
require 'omniauth'
require 'omniauth-infinum'

configure do
  enable :sessions
  use OmniAuth::Builder do
    provider :infinum, ENV['SINATRA_INFINUM_KEY'], ENV['SINATRA_INFINUM_SECRET']
  end
end

get '/' do
  erb :index
end

get '/auth/infinum/callback' do
  omniauth_info = request.env['omniauth.auth']
  "Hello #{omniauth_info[:extra][:first_name]} #{omniauth_info[:extra][:last_name]}. You have successfully signed in on this supper dupper app! #{ENV['RACK_ENV']}"
end

get '/auth/failure' do
  "Potatos! Did not succeed to sign in! The Reason is: #{params[:message]}"
end
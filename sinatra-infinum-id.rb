require 'sinatra'
require 'omniauth'
require 'omniauth-infinum'

configure do
  enable :sessions
  use OmniAuth::Builder do
    provider :infinum, ENV['SINATRA_INFINUM_KEY'], ENV['SINATRA_INFINUM_SECRET']
  end
end

helpers do
  
  def current_user_name
    if session[:user_id]
      session[:user_id][:extra][:first_name]
    end
  end

  def signed_in?
    !!current_user_name
  end

end


get '/' do
  erb :index
end

get '/auth/infinum/callback' do
  omniauth_info = request.env['omniauth.auth']
  session[:user_id] = omniauth_info
  "Hello #{omniauth_info[:extra][:first_name]} #{omniauth_info[:extra][:last_name]}. You have successfully signed in on this supper dupper app! #{ENV['RACK_ENV']}"
end

get '/auth/failure' do
  "Potatos! Did not succeed to sign in! The Reason is: #{params[:message]}"
end

get '/logout' do
  session[:user_id] = nil
  redirect "#{OmniAuth::Strategies::Infinum.url}/users/sign_out?redirect_to=#{request.base_url}", notice: 'You have successfully signed out!'
end
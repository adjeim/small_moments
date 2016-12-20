require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'


set :database, 'sqlite3:test.sqlite3'
enable :sessions

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end



get '/' do
	erb :home
end


get '/faq' do
	erb :faq

end






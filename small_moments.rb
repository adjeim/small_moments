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


# general routes
get '/' do
	erb :home
end


get '/about' do
	erb :about
end

#users - create
post '/users/create' do
	@user = User.new(name: params['name'], email: params['email'], password: params['password'])
	@user.save
	# flash[:notice] = "Thanks for updating us, #{@user.name}!"
	redirect "/users/#{@user.id}"

end



#users - read
get '/users/:id' do
	@user = User.find(params['id'])
	erb :user
end
# need to add: if user not found, redirect to home page



#users - updates
post '/users/:id/update' do
	@user = User.find(params['id'])
	@user.update(name: params['name'], email: params['email'], password: params['password'])
	redirect "/users/#{@user.id}"
end



#users - destroy
post '/users/:id/delete' do
	@user = User.find(params['id'])
	session[:user_id] = nil
	@user.destroy
	redirect '/'
end


#posts - create
get '/users/:id/posts/new' do
	@user = User.find(params['id'])
	erb :new_post
end
# user can create a new post on their profile

post '/users/:id/posts/create' do
	@user = User.find(params['id'])
	@post = Post.new(user_id: @user.id, title: params['title'], content: params['content'])
	# @post.user_id = @user.id
	@post.save
	redirect "users/#{@user.id}/posts/#{@post.id}"
end


#posts - read (individual post)
get 'users/:id/posts/:id' do
	erb :post
end


#posts - update

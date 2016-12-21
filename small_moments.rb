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



#login
post '/login' do
	@user = User.where(email: params['email']).first
	if @user && @user.password == params['password']
		session[:user_id] = @user.id
		flash[:notice] = "Welcome back to Small Moments!"
		redirect "/users/#{session[:user_id]}"
	else
		flash[:alert] = "Something doesn't sound right. Try again?"
		redirect "/users/#{@user.id}"
	end
end


#logout
post '/logout' do
	session[:user_id] = nil
	redirect "/"
end



#users - create (from the home page)
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



#users - updates (from the user's profile page)
post '/users/:id/update' do
	@user = User.find(params['id'])
	@user.update(name: params['name'], email: params['email'], password: params['password'])
	redirect "/users/#{@user.id}"
end



#users - destroy (from the user's profile page)
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

	@post.save

	@post_number = @user.posts.length
	# @post = @user.posts[post_number]
	redirect "users/#{@user.id}/posts/#{@post_number}"
end
# this is super cool!
# in mine, i want each user's post to be able to count up
# add more comments to explain how this works


#posts - read (a user's individual post)
get '/users/:user_id/posts/:post_id' do
	@user = User.find(params['user_id'])
	# @post = Post.find(params['post_id'])
	# @post = Post.where(user_id: @user.id)
	post_number = params['post_id'].to_i-1
	@post = @user.posts[post_number]
	erb :post
end
# this is also super cool!
# add more comments to explain how this works


#posts - update






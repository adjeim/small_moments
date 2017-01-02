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
	@posts = Post.all
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
	@user = User.find(session[:user_id])
	# session[:user_id] = @user.id
	# @user = User.find(params['id'])
	erb :user
end
# need to add: if user not found, redirect to home page



#users - updates (from the user's profile page)
post '/users/:id/update' do
	@user = User.find(session[:user_id])
	@user.update(name: params['name'], email: params['email'], password: params['password'])
	redirect "/users/#{@user.id}"
end



#users - destroy (from the user's profile page)
post '/users/:id/delete' do
	@user = User.find(session[:user_id])
	session[:user_id] = nil
	@user.destroy
	redirect '/'
end


#posts - create
get '/posts/new' do
	@user = User.find(session[:user_id])
	erb :new_post
end
# user can create a new post on their profile

post '/posts/create' do
	@user = User.find(session[:user_id])

	tags = []
    params[:tags].each do |tag|
        tags << Tag.new(name: tag)
    end

	@post = Post.new(user_id: @user.id, title: params['title'], content: params['content'], tags: tags)
	@post.save

	# @post_number = @user.posts.length
	redirect "/posts/#{@post.id}"
end
# super cool -- creates a new post that one can view at the number of that user's posts
# user can select tags for their posts



#posts - read (all user's own posts)
get '/posts' do
	@user = User.find(session[:user_id])
	@posts = @user.posts
	erb :posts

end


# posts - read (user's own individual post)
get '/posts/:id' do
	@user = User.find(session[:user_id])
	@post = Post.find(params['id'])
	# @post = @user.posts[post_number]
	erb :post
end



#posts - update
get '/posts/:id/edit' do
	@user = User.find(session[:user_id])
	@post = Post.find(params['id'])
	# post_number = params['post_id'].to_i-1
	# @post = @user.posts[post_number]

	erb :edit_post
end


post '/posts/:id/update' do
	@user = User.find(session[:user_id])
	@post = Post.find(params['id'])
	# post_number = params['post_id'].to_i-1
	# @post = @user.posts[post_number]

	@post.update(title: params['title'], content: params['content'])
	@post.save

	redirect "/posts/#{@post.id}"
	# redirect :post

end
# should update post, but currently doesn't update tags
# why doesn't this show?


#posts - delete
post '/posts/:id/delete' do
	@user = User.find(session[:user_id])
	@post = Post.find(params['id'])
	# @user = User.find(params['user_id'])
	# post_number = params['post_id'].to_i-1
	# @post = @user.posts[post_number]

	@post.destroy
	redirect '/posts'
end




# read other user's individual and collections of posts

#posts - read all of another user's posts
get '/users/:id/posts' do
	@user = User.find(params['id'])
	@posts = @user.posts
	# @tags = @user.posts.tags
	erb :others_posts
end


# posts - read (a user's individual post)
get '/users/:user_id/posts/:post_id' do
	@user = User.find(params['user_id'])
	@post = Post.find(params['post_id'])
	# @post = @user.posts[post_number]
	erb :others_post
end



#tags - create


#user can create a new tag or select a tag to attach to their post



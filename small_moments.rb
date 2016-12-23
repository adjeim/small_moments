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

	tags = []
    params[:tags].each do |tag|
        tags << Tag.new(name: tag)
    end

	@post = Post.new(user_id: @user.id, title: params['title'], content: params['content'], tags: tags)
	@post.save

	@post_number = @user.posts.length
	redirect "users/#{@user.id}/posts/#{@post_number}"
end
# super cool -- creates a new post that one can view at the number of that user's posts
# user can select tags for their posts



#posts - read (a user's individual post)
get '/users/:user_id/posts/:post_id' do
	@user = User.find(params['user_id'])

	post_number = params['post_id'].to_i-1
	@post = @user.posts[post_number]
	erb :post
end
# super cool!



#posts - update
get '/users/:user_id/posts/:post_id/edit' do
	@user = User.find(params['user_id'])
	post_number = params['post_id'].to_i-1
	@post = @user.posts[post_number]

	erb :edit_post
end


post '/users/:user_id/posts/:post_id/update' do
	@user = User.find(params['user_id'])
	post_number = params['post_id'].to_i-1
	@post = @user.posts[post_number]

	@post.update(title: params['title'], content: params['content'], tags: params['tags'])

	redirect "users/#{@user.id}/posts/#{@post_number}"

end
# should update post, but currently doesn't update tags
# why doesn't this show?


#posts - delete




#tags - create


#user can create a new tag or select a tag to attach to their post



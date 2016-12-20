class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
	has_many :tags
end

class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
end

class Post < ActiveRecord::Base
	has_many :comments
	has_and_belongs_to_many :tags
	belongs_to :user
end

class Tag < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :posts
end
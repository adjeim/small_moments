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
	has_many :tags, through: :post_tag
	belongs_to :user
end

class Tag < ActiveRecord::Base
	belongs_to :user
	has_many :posts, through: :post_tag
end

class PostTag < ActiveRecord::Base
	belongs_to :post
	belongs_to :tag
end

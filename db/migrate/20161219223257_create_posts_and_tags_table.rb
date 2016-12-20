class CreatePostsAndTagsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :posts do |t|
		t.integer :user_id
  		t.string :title
  		t.text :content
  	end

  	create_table :tags do |t|
  		t.integer :user_id
  		t.text :name
  	end

  	create_table :posts_tags, id: false do |t|
  		t.belongs_to :post, index: true
  		t.belongs_to :tag, index: true
  	end
  end
end
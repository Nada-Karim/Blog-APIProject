class RemoveTagsFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :tags, :string
  end
end

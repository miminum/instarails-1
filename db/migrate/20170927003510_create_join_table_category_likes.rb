class CreateJoinTableCategoryLikes < ActiveRecord::Migration[5.1]
  def change
    create_join_table :photos, :users, force: true, table_name: :likes do |t|
      t.index [:photo_id, :user_id], unique: true # Can see all users wh liked a specific person
      # t.index [:user_id, :photo_id] # Can see all phtoes liked by a specific person

      t.timestamp :created_at
    end
  end
end

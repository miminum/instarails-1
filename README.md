## rails g migration CreateJoinTableCategoryLikes user photo
creates join table
### migration file
- then added ' table_name: :likes' to migration file
- unhashed 't.index [:photo_id, :user_id]' wihch allows to see all phtos liked by a specific person
- unique: :true added
- t.timestamps :created_at
- force: true

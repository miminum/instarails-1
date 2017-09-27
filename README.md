# Challenge 27/09/2017
- Challenge: add location field to photo — hint use migration: https://stackoverflow.com/a/4834906
- Challenge: private message — hint similar to comments, but messages are between two users, not between a user and a photo
- Challenge (advanced): add geolocation lookup of location — hint use geocoder gem

# Likes
## rails g migration CreateJoinTableCategoryLikes user photo
creates join table
### migration file
- then added ' table_name: :likes' to migration file
- unhashed 't.index [:photo_id, :user_id]' wihch allows to see all phtos liked by a specific person
- unique: :true added
- t.timestamps :created_at
- force: true

### /models/photo.rb
- has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes
- this is what happens behind the scences for above line: 
---
    photo = Photo.first
    all_people_who_liked_that_photo = photo.likers

    other_person.User.second *(To make other_person like)*
    photo.likers << other_person    
- and the below code:
---
    def liked_by?(user)
        likers.exist?(user.id)
    end

    def toggle_liked_by(user)
        if likers.exist?(user.id)
            likers.destroy(user.id)
        else
            likers << user
        end
    end

### /models/user.rb
- has_many :photos

### photos/show.html.erb
- like button
---
    <%= form_with(model: @photo, method: :patch) do |f| %>
      <% liked = @photo.liked_by?(current_user) %>
      <%= f.hidden_field :liked, value:liked%>
      <%= f.button liked ? 'Unlike' : 'Like' %>
    <% end %>

### photos_controller.rb
- added to def update:
---
    if is_liking?
        # Toggle whether this photo is liked by the current user
        @photo.toggle_liked_by(current_user)
        format.html { redirect_to @photo }
        format.json { render :show, status: :ok, location: @photo }
- added to private
---
    def is_liking?
      # is there a 'liked' field in the form?
      params.require(:photo)[:liked].present?
    end

# Creating comments relationship
## rails g scaffold Comment photo:references user:references content:text
### migration file 
- t.index :created_at # Allow us to sort chronologically

### routes.rb
-   resources :photos do
    resources :comments
  end

### index.html.erb
- add new_photo_comment_path(@photo)

### comments_controller.rb 
- add @songs
--- 
    def set_photo
      @photo = Photo.find(params[:photo_id])
    end
- add to top
---     
    before_action :set_photo
- to def index
--- 
     @new_comment = Comment.new
- replace :new with :index in the def create else statement
---
    def create
      @comment = Comment.all
      @new_comment = Comment.new(comment_params)
      @new_comment.user = current_user
      @new_comment.photo = @photo

      respond_to do |format|
        if @new_comment.save
          format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
        else # Calidation errors
          format.html { render :index }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
- In destroy
---
    comments_photos_url(@photo)

### form.html.erb
- [@photo, comment]
- delete index.new.html from views/comments
- delete sections with user and photo

### index.html.erb
- changes
---
     <td><%= link_to 'Show', [@photo, comment] %></td>
     <td><%= link_to 'Edit', edit_photo_comment_path(comment) %></td>
     <td><%= link_to 'Destroy', [@photo, comment], method: :delete, data: { confirm: 'Are you sure?' } %></td>

### _comment.html.erb
created from scratch

### edit.html.erb
- <%= link_to 'Back', photo_comments_path(@photo) %>
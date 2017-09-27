class Photo < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  
  belongs_to :user
  has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes
  has_many :comments

  def liked_by?(user)
    likers.exists?(user.id)
  end

  def toggle_liked_by(user)
    if likers.exists?(user.id)
      likers.destroy(user.id)
    else
      likers << user
    end
  end
end

# photo = Photo.first
# all_people_who_liked_that_photo = photo.likers

# other_person.User.second
# # To make other_person like
# photo.likers << other_person
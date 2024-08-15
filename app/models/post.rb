class Post < ApplicationRecord
  after_create :schedule_deletion
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings


  def schedule_deletion
    PostDeletionJob.perform_in(24.hours, id)
  end
end

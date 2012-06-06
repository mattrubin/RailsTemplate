class Post < ActiveRecord::Base
  MAX_LENGTH = 140
  attr_accessible :content
  belongs_to :user

  validates :content, presence: true, length: { maximum: MAX_LENGTH }
  validates :user_id, presence: true

  default_scope order: 'posts.created_at DESC'
end

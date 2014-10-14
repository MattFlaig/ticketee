class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates_presence_of :title, :description
  validates_length_of :description, minimum: 10

  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end

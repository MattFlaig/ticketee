class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :assets
  has_many :comments
  accepts_nested_attributes_for :assets
  
  validates_presence_of :title, :description
  validates_length_of :description, minimum: 10

end

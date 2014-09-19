class Ticket < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :title, :description
end

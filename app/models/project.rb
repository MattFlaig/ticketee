class Project < ActiveRecord::Base
	has_many :tickets, dependent: :destroy
	has_many :permissions, :as => :thing

	scope :readable_by, lambda { |user|
		joins(:permissions).where(:permissions => {:action => "view",
																							 :user_id => user.id})
	}

	validates_presence_of :name
	validates_uniqueness_of :name

	def self.for(user)
		user.admin? ? Project.all : Project.readable_by(user)
	end
end

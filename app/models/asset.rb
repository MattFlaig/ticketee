class Asset < ActiveRecord::Base
	has_attached_file :asset, :path => (Rails.root + "files/:id").to_s,
	                          :url => "/files/:id"
	belongs_to :ticket
	validates_attachment_content_type :asset, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end

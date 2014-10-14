class Asset < ActiveRecord::Base
	has_attached_file :asset
	validates_attachment_content_type :asset, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end

class AddAttachmentAssetToTickets < ActiveRecord::Migration
  def self.up
    change_table :tickets do |t|
      t.attachment :asset
    end
  end

  def self.down
    remove_attachment :tickets, :asset
  end
end

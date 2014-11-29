class Ticket < ActiveRecord::Base
  # searcher do 
  # 	label :tag, :from => :tags, :field => :name 
  # 	label :state, :from => :state, :field => "name"
  # end

  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :assets
  has_many :comments

  attr_accessor :tag_names

  accepts_nested_attributes_for :assets

  has_and_belongs_to_many :tags
  has_and_belongs_to_many :watchers, :join_table => "ticket_watchers", :class_name => "User"
  
  validates_presence_of :title, :description
  validates_length_of :description, minimum: 10

  before_create :associate_tags
  after_create :creator_watches_me

  def tag!(tags)
    tags = tags.split(" ").map do |tag|
      Tag.create(name: tag)
    end

    self.tags << tags
  end

  private

  def associate_tags
    if tag_names
      tag_names.split(" ").each do |name|
        self.tags << Tag.find_or_create_by(name: name)
      end
    end
  end

  def creator_watches_me
    if user
      self.watchers << user unless self.watchers.include?(user)
    end
  end

end

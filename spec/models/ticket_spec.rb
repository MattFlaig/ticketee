require 'rails_helper'

RSpec.describe Ticket, :type => :model do
  it {should belong_to(:project)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should ensure_length_of(:description).is_at_least(10)}
end

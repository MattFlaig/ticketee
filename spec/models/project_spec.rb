require 'rails_helper'

RSpec.describe Project, :type => :model do
  it {should validate_presence_of(:name)}
  it {should have_many(:tickets)}
end

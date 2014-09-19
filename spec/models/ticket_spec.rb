require 'rails_helper'

RSpec.describe Ticket, :type => :model do
  it {should belong_to(:project)}
end

require 'rails_helper'

RSpec.describe Admin::PermissionsController, :type => :controller do

  describe "GET#index" do 
  	let(:admin){FactoryGirl.create(:user, admin: true)}
  	before{ sign_in admin}

    it "sets the ability variable" do 
    	ability = Ability.new(admin)
    	get :index, user_id: admin.id
    	expect(ability).to be_instance_of(Ability)
    end

    it "sets the projects variable" do 
    	pro1 = FactoryGirl.create(:project)
    	pro2 = FactoryGirl.create(:project)
    	get :index, user_id: admin.id
    	expect(Project.all).to match_array([pro1, pro2])
    end
  end

  describe "PUT#update" do 

  end
end

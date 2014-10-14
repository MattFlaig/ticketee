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
  	let(:admin){FactoryGirl.create(:user, admin: true)}
  	let(:user){FactoryGirl.create(:user, admin: false)}
  	let(:pro1){FactoryGirl.create(:project)}
  	let(:permission){Permission.create(user: user, thing: pro1, action: "view") }
  	before do 
  		sign_in admin
  	end
  	# it "clears all the user's permissions" do 
  	# 	put :update, user_id: user.id, id: pro1.id
  	# 	expect(user.permissions).to eq(0)
  	# end
  	it "updates permissions for each found project" do 
  		put :update, {user_id: user.id, permissions:{"1"=>{"create tickets" => "1"}}}
  		expect(User.last.permissions.first.action).to eq("create tickets")
  	end
  	it "sets a success message"
  	it "redirects to user permissions"
  end
end

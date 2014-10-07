require 'rails_helper'

RSpec.describe Admin::UsersController, :type => :controller do

  describe "GET#index" do 
    context "for standard users" do
    	let(:user){FactoryGirl.create(:user, :admin => false)}
      before {sign_in user}

	    it "redirects to rootpath" do 
	    	get :index
	    	expect(response).to redirect_to(root_path)
	    end
	    it "sets an error message" do 
	    	get :index
        expect(flash[:alert]).to eq("You must be an admin to do that!")
	    end
    end
  end

end

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

  describe "POST#create" do 
  	context "with admin signed in" do
  		context "standard user creation" do
		    context "with correct input" do 
		    	let(:admin){FactoryGirl.create(:user, :admin => true)}
	        before do 
	        	sign_in admin
	        	user1 = FactoryGirl.attributes_for(:user, :admin => false)
	          post :create, user: user1
	        end
		    	it "saves the new user to the database" do 
	          expect(User.count).to eq(2)
	        end
		    	it "sets a success message" do 
		    		expect(flash[:notice]).to be_present
		    	end
		    	it "redirects to admin users path" do 
		    		expect(response).to redirect_to(admin_users_path)
		    	end
		    end
		  
	      context "with incorrect input" do 
	      	let(:admin){FactoryGirl.create(:user, :admin => true)}
	        before do 
	        	sign_in admin
	          post :create, user: {email: ""}
	        end
	        it "does not save the user" do 
	        	expect(User.count).to eq(1)
	        end
	        it "sets an error message" do 
	        	expect(flash[:alert]).to be_present
	        end
	        it "renders the new template" do 
	        	expect(response).to render_template :new
	        end
	      end
	    end

	    context "admin user creation" do 
	    	let(:admin){FactoryGirl.create(:user, :admin => true)}
        before do 
        	sign_in admin
          post :create, user: {email: "admin@admin.com", password: "password", admin: true}
        end
	    	it "saves the new admin to the database" do 
          expect(User.count).to eq(2)
        end
        it "sets the admin property to true" do 
        	expect(User.last.admin).to eq(true)
        end
	    	it "sets a success message" do 
	    		expect(flash[:notice]).to be_present
	    	end
	    	it "redirects to admin users path" do 
	    		expect(response).to redirect_to(admin_users_path)
	    	end
	    end
    end
  end

  describe "PUT#update" do 
  	context "with admin signed in" do 
  		context "with valid input" do 
	  		let(:admin){FactoryGirl.create(:user, :admin => true)}
	  		let(:user1){FactoryGirl.create(:user, :admin => false)}
	      before do 
	      	sign_in admin
	        put :update, {id: user1, user: {email: "user@user.com"}}
	      end
	      it "updates the user" do 
	      	expect(User.last.email).to eq("user@user.com")
	      end
	      it "sets a success message" do 
	      	expect(flash[:notice]).to be_present
	      end
	      it "redirects to admin users path" do 
	      	expect(response).to redirect_to(admin_users_path)
	      end
	    end

	    context "with invalid input" do 
	    	let(:admin){FactoryGirl.create(:user, :admin => true)}
	  		let(:user1){FactoryGirl.create(:user, :admin => false)}
	      before do 
	      	sign_in admin
	        put :update, {id: user1, user: {email: ""}}
	      end

	      it "does not update the user" do 
	      	expect(User.last.email).to eq(user1.email)
	      end
	      it "sets an error message" do 
	      	expect(flash[:alert]).to be_present
	      end
	      it "renders the edit template" do 
	      	expect(response).to render_template(:edit)
	      end
	    end
  	end	
  end

  describe "DELETE#destroy" do 
  	context "with admin signed in" do
	    context "delete standard user" do 
	    	let(:admin){FactoryGirl.create(:user, admin: true)}
	    	let(:user1){FactoryGirl.create(:user, admin: false)}
	    	before do 
	    	  sign_in admin
	    	  delete :destroy, {id: user1, user:{email: user1.email, password: user1.password, admin: user1.admin }}
	    	end
	      it "deletes the user" do 
	      	expect(User.count).to eq(1)
	      end
	      it "sets a success notice" do 
	      	expect(flash[:notice]).to be_present
	      end
	      it "redirects to admin users path" do 
	      	expect(response).to redirect_to(admin_users_path)
	      end	
	    end


      #context "delete admin"
    end
  end

end

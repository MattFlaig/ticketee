require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
	describe "GET#index" do 
		it "sets the projects variable" do 
      pro1 = Project.create(name: "pro1")
      pro2 = Project.create(name: "pro2")
      get :index
      expect(Project.all).to match_array([pro1,pro2])
		end
	end
	describe "GET#new" do 
		it "assigns project to be a new instance of class Project" do
      get :new
      expect(assigns(:project)).to be_instance_of(Project)
    end
	end

	describe "GET#show" do 
		it"set the project variable" do
			pro1 = Project.create(name: "pro1")
	    get :show, id: pro1.id
	    expect(assigns(:project)).to eq(pro1)
    end
	end

	describe "POST#create" do
	  context "with correct input" do 
	    it "creates a new project" do 
	      post :create, project:{name: "pro1"}
	      expect(Project.count).to eq(1)
	    end
	    it "gives a success message" do 
        post :create, project:{name: "pro1"}
        expect(flash[:notice]).to be_present
	    end
	    it "redirects to show" do 
	    	post :create, project:{name: "pro1"}
	    	expect(response).to redirect_to '/projects/1'
	    end

	  end

	  context "with incorrect input" do 
      it "does not create the project" do 
        post :create, project:{name: ""}
        expect(Project.count).to eq(0)
      end
      it "sets an error message" do 
        post :create, project:{name: ""}
        expect(flash[:alert]).not_to be_empty
      end
      it "renders the new template" do 
        post :create, project:{name: ""}
        expect(response).to render_template :new
      end
	  end
	end

end

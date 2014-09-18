require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
	describe "GET#index" do 
		it "sets the projects variable" do 
      pro1 = FactoryGirl.create(:project)
      pro2 = FactoryGirl.create(:project)
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
			pro1 = FactoryGirl.create(:project)
	    get :show, id: pro1.id
	    expect(assigns(:project)).to eq(pro1)
    end
	end

	describe "POST#create" do
	  context "with correct input" do 
	  	before do 
        pro1 = FactoryGirl.attributes_for(:project)
	      post :create, project: pro1
	  	end
	    it "creates a new project" do 
	      expect(Project.count).to eq(1)
	    end
	    it "gives a success message" do 
        expect(flash[:notice]).to be_present
	    end
	    it "redirects to show" do 
	    	expect(response).to redirect_to '/projects/1'
	    end
	  end

	  context "with incorrect input" do 
	  	before do 
        post :create, project:{name: ""}
	  	end
      it "does not create the project" do 
        expect(Project.count).to eq(0)
      end
      it "sets an error message" do 
        expect(flash[:alert]).not_to be_empty
      end
      it "renders the new template" do 
        expect(response).to render_template :new
      end
	  end
	end

	describe "PUT#update" do 
    context "with correct input" do 
    	before do 
        pro1 = FactoryGirl.create(:project)
        put :update, {id: pro1, project: {name: "goggelwopp"}}
    	end
      it "updates the record" do 
      	pro1 = FactoryGirl.create(:project)
      end
      it "sets a success message" do 
      	pro1 = FactoryGirl.create(:project)
      end
      it "redirects to show" do 
      	pro1 = FactoryGirl.create(:project)
      end
    end

    context "with incorrect input" do 
    	let(:pro1) {FactoryGirl.create(:project)}
    	before {put :update, {id: pro1, project: {name: ""}} }
      it "does not update the record" do 
        expect(Project.first.name).to eq(pro1.name)
      end
      it "sets an error message" do 
        expect(flash[:alert]).not_to be_empty
      end
      it "renders the edit template" do 
        expect(response).to render_template :edit
      end
    end
	end

end

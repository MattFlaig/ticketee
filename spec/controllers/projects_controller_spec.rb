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

  describe "GET#show" do 
    context "with existing projects" do
      it"set the project variable" do
        pro1 = FactoryGirl.create(:project)
        get :show, id: pro1.id
        expect(assigns(:project)).to eq(pro1)
      end
    end
    context "with non-existing projects" do 
      it "displays an error for a missing project" do
        get :show, id: "not-here"
        message = "The project you were looking for could not be found."
        expect(flash[:alert]).to eq(message)
      end
      it "redirects to index" do
        get :show, id: "not-here"
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe "restricted access in new, create, edit, update, delete" do
    context "with standard users" do
      let(:user){FactoryGirl.create(:user, :admin => false)}
      let(:project){FactoryGirl.create(:project)}
      before {sign_in user}

      {"new" => "get", 
      "create" => "post", 
      "edit" => "get",
      "update" => "put",
      "destroy" => "delete"}.each do |action, method|
        it "cannot access the #{action} action" do 
          send(method, action.dup, :id => project.id)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eql("You must be an admin to do that!")
        end
      end
    end
  end

	describe "GET#new" do 
    context "with admin signed in" do
      let(:user){FactoryGirl.create(:user, :admin => true)}
      before {sign_in user}

  		it "assigns project to be a new instance of class Project" do
        get :new
        expect(assigns(:project)).to be_instance_of(Project)
      end
    end
	end

	describe "POST#create" do
    context "with admin signed in" do
      let(:user){FactoryGirl.create(:user, :admin => true)}
      before {sign_in user}

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
  end

	describe "PUT#update" do 
    context "with admin signed in" do
      let(:user){FactoryGirl.create(:user, :admin => true)}
      before {sign_in user}

      context "with correct input" do 
        let(:pro1) {FactoryGirl.create(:project)}
      	before do 
          put :update, {id: pro1, project: {name: "goggelwopp"}}
      	end
        it "updates the record" do 
        	expect(Project.first.name).to eq("goggelwopp")
        end
        it "sets a success message" do 
        	expect(flash[:notice]).to be_present
        end
        it "redirects to show" do 
        	expect(response).to redirect_to '/projects/1'
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

	describe "DELETE#destroy" do 
    context "with admin signed in" do
      let(:user){FactoryGirl.create(:user, :admin => true)}
  		before do
        sign_in user
  			pro1 = FactoryGirl.create(:project)
        delete :destroy, {id: pro1, project: {name: pro1.name}} 
      end
      it "deletes the project" do 
        expect(Project.count).to eq(0)
      end
      it "sets a notice" do 
        expect(flash[:notice]).to be_present
      end
      it "redirects to index" do 
        expect(response).to redirect_to projects_path
      end 
    end
	end
end

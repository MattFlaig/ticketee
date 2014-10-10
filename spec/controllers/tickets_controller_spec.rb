require 'rails_helper'

RSpec.describe TicketsController, :type => :controller do
  describe "GET#new" do 
    let(:admin){FactoryGirl.create(:user, admin: true)}
    let(:pro1){FactoryGirl.create(:project)}
    before do
      sign_in admin
    end
    it "sets ticket to be an instance of class Ticket" do 
      get :new, project_id: pro1.id, user_id: admin.id
      expect(assigns[:ticket]).to be_instance_of(Ticket)
    end
  end

  describe "GET#show" do 
    context "with admins" do 
      let(:admin){FactoryGirl.create(:user, admin: true)}
      before{sign_in admin}

      it "sets the ticket variable" do 
        pro1 = FactoryGirl.create(:project)
        tic1 = FactoryGirl.create(:ticket, project_id: pro1.id)
        get :show, project_id: tic1.project_id, id: tic1.id 
        expect(assigns(:ticket)).to eq(tic1)
      end
    end

    context "with standard users who don't have permission" do
      let(:pro1){FactoryGirl.create(:project)}
      let(:tic1){FactoryGirl.create(:ticket, project_id: pro1.id)}
      let(:user){FactoryGirl.create(:user, admin: false)}
      before{sign_in user}

      it "cannot access the show action" do 
        get :show, project_id: tic1.project_id, id: tic1.id 
        expect(response).to redirect_to(root_path)
      end
      it "sets an error message" do
        get :show, project_id: tic1.project_id, id: tic1.id 
        expect(flash[:alert]).to eq("The project you were looking for could not be found.")
      end
    end
  end

  describe "POST#create" do 

    context "with valid input" do 
    	let (:pro1) {FactoryGirl.create(:project)}
      let(:admin){FactoryGirl.create(:user, admin: true)}
    	before do 
        sign_in admin 
      	tic1 = FactoryGirl.attributes_for(:ticket)
      	post :create, ticket: tic1, project_id: pro1.id, user_id: admin.id
    	end
      it "creates the ticket" do 
      	expect(Ticket.count).to eq(1)
      end
      it "associates ticket with project" do 
        expect(Ticket.first.project_id).to eq(pro1.id)
      end
      it "sets a success message" do
      	expect(flash[:notice]).to be_present
      end
      it "redirects to ticket page" do 
        expect(response).to redirect_to '/projects/1/tickets/1'
      end
    end
    context "with invalid input" do
      let(:admin){FactoryGirl.create(:user, admin: true)}

    	before do 
        sign_in admin
    		pro1 = FactoryGirl.create(:project)
      	post :create, ticket: {title: "invalid"}, project_id: pro1.id, user_id: admin.id
      end
      it "does not create a ticket" do 
        expect(Ticket.count).to eq(0)
      end
      it "sets an error message" do 
        expect(flash[:alert]).to be_present
      end
      it "renders the new template" do 
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT#update" do 
    context "with valid input" do 
      let(:admin){ FactoryGirl.create(:user, admin: true)}
      
    	before do 
        sign_in admin
    		pro1 = FactoryGirl.create(:project)
        tic1 = FactoryGirl.create(:ticket, project_id: pro1.id, user_id: admin.id)
        put :update, {id: tic1, ticket:{title: "another one"}, project_id: tic1.project_id}
      end
      it "updates the record" do 
        expect(Ticket.first.title).to eq("another one")
      end
      it "sets a flash success message" do 
      	expect(flash[:notice]).to be_present
      end
      it "redirects to ticket page" do 
      	expect(response).to redirect_to '/projects/1/tickets/1'
      end
    end 
    context "with invalid input" do 
    	let (:pro1) {FactoryGirl.create(:project)}
      let (:admin) {FactoryGirl.create(:user, admin: true)}
    	let (:tic1) {FactoryGirl.create(:ticket, project_id: pro1.id, user_id: admin.id)}
      before do 
        sign_in admin
        put :update, {id: tic1, ticket:{title: ""}, project_id: tic1.project_id}
      end
      it "does not update the record" do 
        expect(Ticket.first).to eq(tic1)
      end
      it "sets an error message" do 
      	expect(flash[:alert]).to be_present
      end
      it "renders the edit page" do 
      	expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE#destroy" do 
  	let (:pro1) {FactoryGirl.create(:project)}
    let(:admin) {FactoryGirl.create(:user, admin: true)}

  	before do 
      sign_in admin
      tic1 = FactoryGirl.create(:ticket, project_id: pro1.id, user_id: admin.id)
      delete :destroy, {id: tic1, ticket: {title: tic1.title, description: tic1.description}, project_id: tic1.project_id, user_id: admin.id}
    end
    it "deletes the record" do 
      expect(Ticket.count).to eq(0)
    end
    it "sets a message that the record was deleted" do 
      expect(flash[:notice]).to eq("Ticket has been deleted")
    end
    it "redirects to show project" do 
      expect(response).to redirect_to "/projects/#{pro1.id}"
    end
  end
end

require 'rails_helper'

RSpec.describe TicketsController, :type => :controller do
  describe "GET#new" do 
    it "sets ticket to be an instance of class Ticket" do 
    	pro1 = FactoryGirl.create(:project)
      get :new, project_id: pro1.id
      expect(assigns[:ticket]).to be_instance_of(Ticket)
    end
  end

  describe "GET#show" do 
    it "sets the ticket variable" do 
      pro1 = FactoryGirl.create(:project)
      tic1 = FactoryGirl.create(:ticket, project_id: pro1.id)
      get :show, project_id: tic1.project_id, id: tic1.id 
      expect(assigns(:ticket)).to eq(tic1)
    end
  end

  describe "POST#create" do 
    context "with valid input" do 
    	let (:pro1) {FactoryGirl.create(:project)}
    	before do 
      	tic1 = FactoryGirl.attributes_for(:ticket)
      	post :create, ticket: tic1, project_id: pro1.id
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
    	before do 
    		pro1 = FactoryGirl.create(:project)
      	post :create, ticket: {title: "invalid"}, project_id: pro1.id
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
    	before do 
    		pro1 = FactoryGirl.create(:project)
        tic1 = FactoryGirl.create(:ticket, project_id: pro1.id)
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
    	let (:tic1) {FactoryGirl.create(:ticket, project_id: pro1.id)}
      before do 
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
end

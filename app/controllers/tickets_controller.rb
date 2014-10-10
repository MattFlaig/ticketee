class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project
  before_action :find_ticket, only: [:show, :edit, :update, :destroy]


  def new
  	@ticket = @project.tickets.build
  end

  def show
  end

 
  def create
    @ticket = @project.tickets.build((ticket_params).merge!(user: current_user))
    if @ticket.save
      flash[:notice] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been created."
      render "new"
    end
  end

  def edit
  end

  def update
    if @ticket.update_attributes(ticket_params)
      flash[:notice] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been updated."
      render "edit"
    end
  end

  def destroy
  	@ticket.destroy
  	flash[:notice] = "Ticket has been deleted"
  	redirect_to @project
  end




  private

  def find_project
  	@project = Project.for(current_user).find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The project you were looking for could not be found."
      redirect_to root_path
  end

  def find_ticket
    @ticket = @project.tickets.find(params[:id])
  end

  def ticket_params
  	params.require(:ticket).permit(:title, :description, :project_id, :user_id)
  end
end

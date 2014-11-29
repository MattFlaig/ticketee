class ProjectsController < ApplicationController
  before_action :authorize_admin!, except: [:index, :show]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :find_project, only: [:show,:edit,:update,:destroy]

  require 'pry'
  
	def index
    @projects = Project.for(current_user).all
	end

	def new
    @project = Project.new
	end

	def show
    @tickets = @project.tickets
	end

	def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = "New Project created successfully"
      redirect_to @project
    else
    	flash[:alert] = "No project created"
    	render 'new'
    end
	end

	def edit
	end

	def update
    @project.update_attributes(project_params)
    #binding.pry
    if @project.save
      flash[:notice] = "Project successfully updated"
      redirect_to @project
    else
    	flash[:alert] = "Project not updated"
    	render 'edit'
    end
	end

	def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Project has been deleted"
    redirect_to projects_path
	end



	private

	def project_params
		params.require(:project).permit(:name)
	end

	def find_project
    @project = Project.for(current_user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The project you were looking for could not be found."
    redirect_to projects_path
  end

end

class ProjectsController < ApplicationController
	def index
    @projects = Project.all
	end

	def new
    @project = Project.new
	end

	def show
		@project = Project.find(params[:id])
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
		@project = Project.find(params[:id])
	end

	def update
    @project = Project.find(params[:id])
    @project.update_attributes(project_params)
    if @project.save
      flash[:notice] = "Project successfully updated"
      redirect_to @project
    else
    	flash[:alert] = "Project not updated"
    	render 'edit'
    end
	end



	private

	def project_params
		params.require(:project).permit(:name)
	end
end

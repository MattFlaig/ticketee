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
    end
	end



	private

	def project_params
		params.require(:project).permit(:name)
	end
end

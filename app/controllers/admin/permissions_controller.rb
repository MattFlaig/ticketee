class Admin::PermissionsController < Admin::BaseController
  before_action :find_user
  require 'pry'

  def index
  	@ability = Ability.new(@user)
  	@projects = Project.all
  end

  def update
    @user.permissions.clear
    unless params[:permissions]==nil
	    params[:permissions].each do |id, permissions|
	    	project = Project.find(id)
	    	permissions.each do |permission, checked|
	    		Permission.create(user: @user, thing: project, action: permission)
	    	end
	    end
      #binding.pry
	  end
	  flash[:notice] = "Permissions updated."
	  redirect_to admin_user_permissions_path(@user)
  end

  private

  def find_user
  	@user = User.find(params[:user_id])
  end

  # def permission_params
  # 	params.require(:permissions).permit(:user, :thing, :action)
  # end

end

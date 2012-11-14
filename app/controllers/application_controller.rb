class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate_active_admin_user!
    authenticate_user! 
    unless current_user.superadmin?
      flash[:alert] = "Unauthorized Access!"
      redirect_to root_path 
    end
  end

  private
    # Overwriting the sign_out redirect path method
	#  def after_sign_out_path_for(resource_or_scope)
	#    new_user_session_path
	#  end

	def after_sign_in_path_for(resource_or_scope)
	 	stored_location_for(resource_or_scope)
	 	if resource_or_scope.is_a?(User)
	 		user_path(resource_or_scope)
	 	else
	 		super
	 	end
	end

	  #doesn't work yet ... want to redirect to sign_in page after registering
	#  def after_registration_path_for(resource_or_scope)
	#  	new_user_session_path 
	#  end
end

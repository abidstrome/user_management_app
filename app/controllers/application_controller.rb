class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery with: :exception

    def after_sign_out_path_for(resource)
      new_user_session_path
    end
    
  protected
  
  def after_sign_in_path_for(resource)
    users_path
    #'/static_page'
  end

  def after_sign_up_path_for(resource)
    flash[:notice]= 'Registration successful.'
    users_path
  end
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
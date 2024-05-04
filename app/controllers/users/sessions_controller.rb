class Users::SessionsController < Devise::SessionsController
    before_action :check_user, only: :create

    private

    def check_user
        user= User.find_by_email(sign_in_params[:email])
        if user && !user.status
            redirect_to new_user_session_path, flash: {alert: "Your account has been blocked."}
        end
    end
end

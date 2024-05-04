class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:block, :unblock]

  def index
    @users = User.all.order(created_at: :asc)
  end

  def block
    if @user == current_user
      sign_out current_user
      redirect_to new_user_session_path
    else
      @user.update(status: :blocked)
      redirect_to users_path
    end
  end

  def unblock
    begin
      @user.update(status: :active)
      redirect_to users_path
    rescue => e
      redirect_to users_path, alert: "Error unblocking user: #{e.message}"
    end
  end

  def block_users
    user_ids = params[:user_ids].is_a?(String) ? JSON.parse(params[:user_ids]) : params[:user_ids]

    if user_ids.blank?
      render json: { alert: 'No users selected for blocking.' }, status: :unprocessable_entity
      return
    end

    User.where(id: user_ids).update_all(status: User.statuses[:blocked])
    render json: { notice: 'Selected users successfully blocked.' }, status: :ok
  end

  def unblock_users
    begin
      Rails.logger.debug "Raw params received: #{params.inspect}"

      user_ids = params[:user_ids] || []
      raise "user_ids is empty or not an array" unless user_ids.is_a?(Array)

      users = User.where(id: user_ids)
      if users.update_all(status: User.statuses[:active])
        render json: { notice: 'Selected users successfully unblocked.' }, status: :ok
      else
        render json: { alert: 'Failed to unblock users.' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def delete_users
  user_ids = params[:user_ids] || []
  if user_ids.include?(current_user.id.to_s)
    sign_out_user = true
  end

  User.where(id: user_ids).destroy_all

  if sign_out_user
    sign_out current_user
    render json: { redirect_url: new_user_session_path }, status: :ok
  else
    render json: { notice: 'Users deleted successfully' }
  end
rescue => e
  render json: { error: e.message }, status: :unprocessable_entity
end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
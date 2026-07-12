class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: t(".notice")
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t(".notice")
    else
      redirect_to edit_password_path(params[:token]), alert: t(".alert")
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_token_for(:password_reset, params[:token])
      redirect_to new_password_path, alert: t(".alert") unless @user
    end
end

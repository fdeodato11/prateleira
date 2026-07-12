module Admin
  class UsersController < BaseController
    def index
      authorize User
      @users = User.all.order(created_at: :desc)
    end

    def show
      @user = User.find(params[:id])
      authorize @user
    end

    def edit
      @user = User.find(params[:id])
      authorize @user
    end

    def update
      @user = User.find(params[:id])
      authorize @user

      if @user.update(admin: params[:user][:admin])
        redirect_to admin_users_path, notice: "User updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end
end

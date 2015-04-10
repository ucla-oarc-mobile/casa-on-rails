module Admin
  class UsersController < ApplicationController

    before_action :require_session_admin!

    def index

      @users = User.all

    end

    def new

      @user = User.new

    end

    def create

      @user = User.new user_params

      if @user.save
        redirect_to [:admin, @user]
      else
        render 'new'
      end

    end

    def show

      @user = User.find params[:id]

    end

    def edit

      @user = User.find params[:id]

    end

    def update

      @user = User.find params[:id]

      if @user.update user_params
        redirect_to [:admin, @user]
      else
        render 'edit'
      end

    end

    def destroy

      @user = User.find params[:id]
      @user.destroy

      redirect_to admin_users_path

    end

    private

    def user_params
      values = params[:user].permit(:username, :password, :admin, :first_name, :last_name, :email)
      values[:username] = nil if values[:username].length == 0
      values
    end

  end
end
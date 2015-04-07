class SessionController < ApplicationController

  def create

  end

  def store
    user = User.find_by_credentials params[:credentials]
    if user
      bind_session_user! user
      redirect_to root_path
    else
      render 'create'
    end
  end

  def destroy
    unbind_session_user!
    redirect_to root_path
  end

end
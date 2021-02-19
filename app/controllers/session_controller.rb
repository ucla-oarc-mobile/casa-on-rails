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

  def omniauth
    auth = request.env["omniauth.auth"]
    Rails.logger.info "Keycloak login"
    Rails.logger.info auth

    username = auth&.extra&.raw_info&.preferred_username
    first_name = auth&.info&.first_name
    last_name = auth&.info&.last_name
    email = auth&.info&.email

    if username.blank? || first_name.blank? || last_name.blank? || email.blank?
      return redirect_to root_url
    end

    identity = Oauth2Identity.find_or_create_by({
      provider: "shibboleth",
      provider_user_id: "#{username}@ucla.edu"
    })

    unless identity.user
      identity.user = User.create!({
        first_name: first_name,
        last_name: last_name,
        email: email
      })
      identity.save!
    end

    bind_session_user! identity.user

    redirect_to flash[:return_to] ? flash[:return_to] : root_path
  end
end

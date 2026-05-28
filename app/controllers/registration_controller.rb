class RegistrationController < ApplicationController
  allow_unauthenticated_access
  before_action :resume_session, only: :new
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {redirect_to new_session_url, alert: "Try again later."}
  
  def new
    redirect_to root_url, notice: "Вы уже авторизованы" if authenticated?
  end

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for user
      # redirect_to after_authentication_url, notice: "Вы успешно зарегестрировались"
      redirect_to new_session_path, notice: "Вы успешно зарегестрировались"
    else
      redirect_to new_registration_path, notice: user.errors.full_messages
    end
  end

  private

  def user_params
    params.permit(:email_address, :password, :password_confirmation, :first_name, :last_name, :middle_name) 
  end
end

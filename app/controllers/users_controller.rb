class UsersController < ApplicationController
  def new; end

  def create
    password = Devise.friendly_token[0, 20]

    if User.find_by(email: params['email'])
      redirect_to root_path, alert: 'Email has already been taken!'
    else
      begin
        user = User.create!(email: email_params[:email], password: password, password_confirmation: password)
        user.authorizations.create(provider: session[:auth]['provider'], uid: session[:auth]['uid'])
        redirect_to root_path, alert: 'Account create! Please confirm your Email!'
      rescue StandardError => e
        redirect_to root_path, alert: e.message.to_s
      end
    end
  end

  private

  def email_params
    params.permit(:email)
  end
end

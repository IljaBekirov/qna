class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('GitHub')
  end

  def vkontakte
    oauth('vkontakte')
  end

  private

  def oauth(provider)
    auth = request.env['omniauth.auth']
    unless auth.info[:email]
      session[:auth] = auth.except('extra')
      redirect_to user_get_email_path
      return
    end

    @user = FindForOauth.new(auth).call

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end

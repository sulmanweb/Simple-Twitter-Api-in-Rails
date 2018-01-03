## Users signs in and out here
# All renders are in protected sections
class Auth::SessionsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  # SignIn User
  def create
    # find user based on auth
    @user = User.find_by_username(signin_params[:auth])
    if @user.nil?
      @user = User.find_by_email(signin_params[:auth])
    end
    # invalid user auth
    return render_error_user_not_found if @user.nil?
    # validate password
    return render_error_password_incorrect unless @user.authenticate(signin_params[:password])

    # create a session
    @session = @user.sessions.build
    if @session.save
      push_to_headers
      return render_success_session_save
    else
      return render_error_session_save
    end
  end

  # Logout user
  def destroy
    Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).update(active: false)
    remove_token_headers
    return render_success_logout
  end

  private

  def signin_params
    params.permit(:auth, :password)
  end

  protected

  def render_success_session_save
    render status: :created, template: 'auth/sign_in.json.jbuilder'
  end

  def render_success_logout
    render status: :no_content, json: {}
  end

  def render_error_user_not_found
    render status: :unprocessable_entity, json: {errors: [I18n.t('error.auth.invalid_auth')]}
  end

  def render_error_password_incorrect
    render status: :unprocessable_entity, json: {errors: [I18n.t('error.auth.password_invalid')]}
  end

  def render_error_session_save
    render status: :unprocessable_entity, json: {errors: @session.errors.full_messages}
  end
end
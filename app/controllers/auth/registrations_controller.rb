# User sign ups and account deletions
# All renders in protected section
class Auth::RegistrationsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  # User Sign Up
  def create
    @user = User.new(signup_params)
    if @user.save
      # sign in the user created
      @session = @user.sessions.build
      if @session.save
        # update headers for token
        push_to_headers
        return render_success_user_created
      else
        return render_error_session_save
      end
    else
      return render_error_user_save
    end
  end

  # User self deletion
  def destroy
    current_user.destroy!
    remove_token_headers
    return render_success_user_destroy
  end

  private

  def signup_params
    params.permit(:name, :email, :username, :password)
  end

  protected

  def render_success_user_created
    render status: :created, template: 'auth/sign_in.json.jbuilder'
  end

  def render_success_user_destroy
    render status: :no_content, json: {}
  end

  def render_error_user_save
    render status: :unprocessable_entity, json: {errors: @user.errors.full_messages}
  end

  def render_error_session_save
    render status: :unprocessable_entity, json: {errors: @session.errors.full_messages}
  end

end
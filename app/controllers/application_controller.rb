class ApplicationController < ActionController::API
  helper_method :user_signed_in?
  helper_method :current_user

  before_action :update_user_token
  before_action :update_token_headers

  # User must be signed in before action function
  def authenticate_user!
    if request.headers['sid'].present? && !request.headers['sid'].nil? && request.headers['utoken'].present? && !request.headers['utoken'].nil?
      session = Session.active_sessions.find_by_id(request.headers['sid'])
      if session.nil? || session.utoken != request.headers['utoken']
        render_error_invalid_token and return
      end
    else
      render_error_user_not_signed_in and return
    end
  end

  private

  # Question whether user signed in or not
  def user_signed_in?
    if request.headers['sid'].present? && !request.headers['sid'].nil? && request.headers['utoken'].present? && !request.headers['utoken'].nil?
      if Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).nil?
        return false
      else
        return true
      end
    else
      return false
    end
  end

  # Return current signed in user
  def current_user
    if user_signed_in?
      Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).user
    else
      nil
    end
  end

  # Updates the usage of token
  # sbaig TODO update ip etc
  def update_user_token
    if user_signed_in?
      Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).update(last_used_at: Time.zone.now)
    end
  end

  # return request auth headers
  def update_token_headers
    if user_signed_in?
      response.headers['sid'] = request.headers['sid']
      response.headers['utoken'] = request.headers['utoken']
    end
  end

  # remove auth headers for sign out or user deletion
  def remove_token_headers
    response.headers['sid'] = nil
    response.headers['utoken'] = nil
  end

  # Used in signup and signin
  def push_to_headers
    unless @session.nil?
      response.headers['sid'] = @session.id
      response.headers['utoken'] = @session.utoken
    end
  end

  protected

  def render_error_invalid_token
    render status: :unauthorized, json: {errors: [I18n.t('error.unauthorized')]}
  end

  def render_error_user_not_signed_in
    render status: :unauthorized, json: {errors: [I18n.t('error.unauthorized')]}
  end
end

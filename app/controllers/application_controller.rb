class ApplicationController < ActionController::Base
  private

  def require_signin
    session[:intended_url] = request.url
    redirect_to new_session_url, alert: 'Please sign in first!' unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user?(user)
    current_user == user
  end

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  helper_method :current_user?
  helper_method :current_user
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?, :is_admin?, :deny_access

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def is_admin?
    current_user != nil && current_user.name == "Christopher Erin" 
  end

  def deny_access
      redirect_to root_path, :notice => "Please sign in to access this page."
  end
end

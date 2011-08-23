class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    unless @auth = Authorization.find_from_hash(auth)
      @auth = Authorization.create_from_hash(auth, current_user)
    end
    self.current_user = @auth.user
    redirect_to photos_path 
  end

  def destroy
    current_user = nil
    session.delete(:user_id)
    redirect_to root_path
  end
end

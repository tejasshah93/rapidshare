# Class SessionsController
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.authenticate(params[:session][:email],
                              params[:session][:password])
    if @user
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end

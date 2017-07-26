# Class UsersController
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      redirect_to '/signup'
    end
  end

  def show
    redirect_to '/login' unless session[:user_id]
    @user = User.find(params[:id])
    @documents = @user.documents
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email,
                                 :password)
  end
end

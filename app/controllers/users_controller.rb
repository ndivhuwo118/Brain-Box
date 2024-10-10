class UsersController < ApplicationController

  def search
    @users = User.where('name LIKE ?', "%#{params[:query]}%").limit(10)
    render json: @users
  end
  
end

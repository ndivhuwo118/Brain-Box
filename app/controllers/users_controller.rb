class UsersController < ApplicationController
  def search
    @users = User.where('name LIKE ?', "%#{params[:query]}%").limit(10)
    render json: @users
  end

  def show
    @other_user = User.find_by(nickname: params[:nickname])
  end
end

class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    render json: { status: :ok, message: "successfully following #{@user.name}" }
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    render json: { status: :ok, message: "successfully unfollowing #{@user.name}" }
  end

  def sleep_records
    @user = User.find(params[:id])
    # only friend that can see the sleep record
    follow = Follow.find_by(follower_id: current_user.id, followee_id: @user.id)
    if follow.nil?
      return render json: { status: :bad_request, message: "you need to follow #{@user.name} to see the sleep records" }, status: :bad_request
    end

    return render json: { status: :ok, name: @user.name, sleep_records: @user.sleeps.order(duration: :desc) }
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end

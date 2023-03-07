class Api::V1::UsersController < ApplicationController

  # Creates a new user with the parameters specified in the user_params object and saves it to the database.
  #
  # Arguments:
  #   - user_params: a hash object containing the parameters for the new user, including the user's name, email, and password.
  #
  # Returns:
  #   - A JSON response with a status of :created if the user is successfully saved to the database, or a JSON response with a status of :unprocessable_entity if there are errors in the user_params object preventing the user from being saved.
  def create
    @user = User.new(user_params)
    if @user.save
      render json: Response.new(status: :created, message: "success", data: @user), status: :created
    else
      render json: Response.new(status: :unprocessable_entity, message: "fail", errors: @user.errors.full_messages), status: :unprocessable_entity
    end
  end

  # Creates a follow relationship between the current user and the specified user.
  #
  # Arguments:
  #   - params[:id]: an Integer representing the id of the user to follow
  #
  # Returns:
  #   - A JSON response with a status of :ok and a message indicating that the follow relationship was successfully created.
  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    render json: Response.new(status: :ok, message: "successfully following #{@user.name}")
  end

  # Removes the follow relationship between the current user and the specified user.
  #
  # Arguments:
  #   - params[:id]: an Integer representing the id of the user to unfollow
  #
  # Returns:
  #   - A JSON response with a status of :ok and a message indicating that the follow relationship was successfully removed.
  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    render json: Response.new(status: :ok, message: "successfully unfollowing #{@user.name}")
  end


  # Retrieves sleep records for a user and returns them as JSON data.
  # Only a friend of the user can access their sleep records.
  #
  # Arguments:
  #   - params[:id]: an Integer representing the user's id whose sleep records are being accessed
  #
  # Returns:
  #   - JSON data containing the user's sleep records if the user making the request is a friend of the user.
  #   - A JSON response with a bad request status and an error message if the user making the request is not a friend of the user.
  def sleep_records
    @user = User.find(params[:id])
    # Check if user making the request is a friend of the user.
    follow = Follow.find_by(follower_id: current_user.id, followee_id: @user.id)
    if follow.nil?
      return render json: Response.new(status: :bad_request, message: "you need to follow #{@user.name} to see the sleep records"), status: :bad_request
    end

    # Return the user's sleep records as JSON data.
    render json: Response.new(status: :ok, message: @user.name, data: @user.sleeps.where.not(duration: nil).order(duration: :desc))
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end
end

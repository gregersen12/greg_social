class FriendRequestsController < ApplicationController
	before_action :set_friend_request, except: [:index, :create]
  skip_authorization_check

	def index
  	@incoming = FriendRequest.where(friend: current_user)
    @outgoing = current_user.friend_requests
	end

  def create
    friend = User.find(params[:friend_id])
    @friend_request = current_user.friend_requests.new(friend: friend)
    if @friend_request.save
      render :show, status: :created, location: @friend_request
      flash.now[:success] = "Friend request succesfully sent!"
    else
      render json: @friend_request.errors, status: :unprocessable_entity
      flash.now[:error] = "There was an error saving friend"
    end
  end

  def update
    @friend_request.accept
    head :no_content
  end

  def destroy
    @friend_request.destroy
    head :no_content
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end

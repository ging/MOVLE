class UsersController < ApplicationController
  before_action :find_user

  def show
  end

  private

  def find_user
    @profile_user = User.find_by_id(params[:id])
    authorize! :read, @profile_user
    @isProfileOwner = (user_signed_in? and current_user.id==@profile_user.id)
  end

end
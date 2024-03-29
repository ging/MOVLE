class UsersController < ApplicationController
  before_action :find_user
  load_and_authorize_resource :except => [:show_scormfiles, :show_presentations, :show_files]

  def show
    show_presentations
  end

  def show_presentations
    @presentations = @profile_user.presentations.order('updated_at DESC')
    @presentations = @presentations.public_items unless @isProfileOwner
  end

  def show_files
    @files = @profile_user.documents
    @files = @files.public_items unless @isProfileOwner
    @files = @files.sort_by(&:updated_at).reverse
  end

  private

  def find_user
    @profile_user = User.find_by_id(params[:id])
    authorize! :read, @profile_user
    @isProfileOwner = (user_signed_in? and current_user.id==@profile_user.id)
  end

end
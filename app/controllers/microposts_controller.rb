class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to current_user}
        format.json { render json: @micropost, status: :created, location: @micropost }
      else
        render home_path
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or user_path(current_user)
  end
  
  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
  
end

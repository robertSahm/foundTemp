class InviteController < ApplicationController
  
  def show
    number = 649387
    
    # remove the permalink add-number from the id
    id = params[:id].to_i - number
    @gift = Gift.find(id)
    @giver = @gift.giver
    
    
    # check to see if its a mobile browser here
    # if so , change the render format to .mobile
    # add that format to the views folder and add to respond_to
    request.format   = :mobile if sniff_browser
    
    respond_to do |format|
      format.html # detail.html.erb
      format.json { render json: @gift }
    end

  end
  
end

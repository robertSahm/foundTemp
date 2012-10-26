class MerchantsController < ApplicationController
  
  def index
    @providers = current_user.providers    

    respond_to do |format|
      if @providers.count == 1
        format.html { redirect_to merchant_path(@providers.pop) }
      else
        format.html
      end
    end
  end

  def show
    @provider = Provider.find(params[:id])
    @menu = create_menu_from_items(@provider)
    @gifts = Gift.get_activity_at_provider(@provider)
  end

  def orders
    @provider = Provider.find(params[:id])
    # @gifts = Gift.get_provider(@provider)
    @gifts = Gift.get_all_orders(@provider)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gifts }
    end
  end

  def past_orders
    @provider = Provider.find(params[:id])
    @gifts = Gift.get_history_provider(@provider)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gifts }
    end
  end

  def detail
    @gift = Gift.find(params[:id])
    @giver = @gift.giver
    @receiver = @gift.receiver
    @provider = @gift.provider
    if @gift.order.server_id
      @server = User.find(@gift.order.server_id) 
    else
      @server = User.new(first_name: "missing", last_name: "person")
    end
    respond_to do |format|
      format.html # detail.html.erb
      format.json { render json: @gift }
    end
  end

  def order
    @gift = Gift.find(params[:id])
    @redeem = Redeem.find_by_gift_id(@gift)
    @provider = @gift.provider
    
    if @redeem
      @order = Order.new(redeem_id: @redeem.id, gift_id: @gift.id, server_id: current_user.id, provider_id: @provider.id)
    else
      # no redeem = no order possible
      @order = Order.new
    end


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @redeem }
    end
  end
  
  def completed
    @order = Order.find(params[:id])
    @gift = @order.gift
    @giver = @gift.giver
    @receiver = @gift.receiver
    @provider = @order.provider
    if @order.server_id
      @server = User.find(@order.server_id) 
    else
      @server = User.new(first_name: "missing", last_name: "person")
    end
    respond_to do |format|
      format.html # detail.html.erb
      format.json { render json: @gift }
    end
  end

  def customers
    @provider = Provider.find(params[:id])    
    @user     = current_user
    @users    = (current_user.blank? ? User.all : User.find(:all, :conditions => ["id != ?", current_user.id]))
    # list customers on the screen with most recent activity first
        # most drinks ordered
        # most money spent
    # check all the gifts , get the giver and receiver user ids
    # assign those ids to the gift.updated_at field 
    # make a uniq array of all user ids
    # remove employees from that list 
    # list those customers on the screen by gift.updated_at
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def staff
    @provider = Provider.find(params[:id])
    @staff    = @provider.users
  end


end

class GiftsController < ApplicationController

  def index
    @user = current_user
    @gifts = Gift.get_all_gifts(@user)

    # ActiveRecord::Base.logger = Logger.new("in method")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gifts }
    end
  end
  
  def past
    @user = current_user
    @gifts = Gift.get_past_gifts(@user)
    # ActiveRecord::Base.logger = Logger.new("in method")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gifts }
    end
  end
  
  def buy
    @user = current_user
    @gifts, @past_gifts = Gift.get_buy_history(@user)
    @recents = Gift.get_buy_recents(@user)
    
    respond_to do |format|
      format.html 
      format.json { render json: @gifts }
    end
  end
  
  def activity
    @user = current_user
    @gifts = Gift.get_activity
    
    respond_to do |format|
      format.html 
      format.json { render json: @gifts }
    end
  end

  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gift }
    end
  end
  
  def detail
    @gift = Gift.find(params[:id])
    @giver = @gift.giver

    respond_to do |format|
      format.html # detail.html.erb
      format.json { render json: @gift }
    end
  end
  
  def completed
    @order    = Order.find(params[:id])
    @gift     = @order.gift
    @giver    = @gift.giver
    @receiver = @gift.receiver
    @provider = @order.provider
    if @order.server_id
      @server = User.find(@order.server_id) 
    else
      @server = User.new(first_name: "missing", last_name: "person")
    end
    respond_to do |format|
      format.html 
      format.json { render json: @gift }
    end    
  end

  def bill
    @gift     = Gift.new
    @provider = Provider.find(params[:provider_id])
    @receiver = User.find(params[:receiver_id])
    @item     = Item.find(params[:item_id])
    @gift.provider_id     = @provider.id
    @gift.provider_name   = @provider.name
    @gift.receiver_id     = @receiver.id
    @gift.receiver_name   = @receiver.username
    @gift.giver_name      = current_user.username
    @gift.giver_id        = current_user.id
    @gift.receiver_phone  = @receiver.phone
    @gift.item_id         = @item.id
    @gift.price           = params[:price]
    @gift.item_name       = @item.item_name
    @gift.quantity      ||= 1
    @gift.category        = @item.category
    @provider.sales_tax ||= "7.25"
    @disabled = @gift.quantity == 1 ? 'disabled' : ''

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gift }
    end
  end

  def new
    if params[:gift]
      @gift = Gift.new(params[:gift])
      item = params[:item]
      price = params[:price]
      @gift.item_id = item.id
      @gift.price = price
      @gift.item_name = item.item_name
    else
      @gift = Gift.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gift }
    end
  end
  
  def browse
    # @users = (current_user.blank? ? User.all : User.find(:all, :conditions => ["id != ?", current_user.id]))
    @users = User.all
    @providers = Provider.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gift }
    end
  end
  
  def browse_with_contact
    @user = User.find(params[:id])
    @providers = Provider.all
  end
  
  def browse_with_location
    @provider = Provider.find(params[:id])
    # @users = User.find(:all, :conditions => ["id != ?", current_user.id])
    @users = User.all
    @menu = create_menu_from_items(@provider)  

  end
  
  def choose_from_menu
    @provider = Provider.find(params[:provider_id])
    @receiver = User.find(params[:user_id])
    @menu = create_menu_from_items(@provider)
    @gift                 = Gift.new
    @gift.provider_id     = @provider.id
    @gift.provider_name   = @provider.name
    @gift.receiver_id     = @receiver.id
    @gift.receiver_name   = @receiver.username
    @gift.giver_name      = current_user.username
    @gift.giver_id        = current_user.id
    @gift.receiver_phone  = @receiver.phone     
  end

  def choose_from_contacts
    @provider = Provider.find(params[:provider_id])
    @item  = Item.find(params[:item_id])
    @users = User.all
    @price = params[:price]
    @gift               = Gift.new
    @gift.provider_id   = @provider.id
    @gift.provider_name = @provider.name
    @gift.item_id       = @item.id
    @gift.item_name     = @item.item_name
    @gift.giver_name    = current_user.username
    @gift.giver_id      = current_user.id   
  end

  def edit
    @gift = Gift.find(params[:id])
  end

  def create
    @gift = Gift.new(params[:gift])

    respond_to do |format|
      if @gift.save
        format.html { redirect_to @gift, notice: 'Gift was successfully created.' }
        format.json { render json: @gift, status: :created, location: @gift }
      else
        #format.html { render action: "new" }
        format.json { render json: @gift.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @gift = Gift.find(params[:id])

    respond_to do |format|
      if @gift.update_attributes(params[:gift])
        format.html { redirect_to @gift, notice: 'Gift was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gift.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @gift = Gift.find(params[:id])
    @gift.destroy

    respond_to do |format|
      format.html { redirect_to gifts_url }
      format.json { head :no_content }
    end
  end
  
end

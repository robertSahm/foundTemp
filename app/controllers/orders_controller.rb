class OrdersController < ApplicationController

  def index
    @orders = Order.all

    respond_to do |format|
      format.html 
      format.json { render json: @orders }
    end
  end

  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html 
      format.json { render json: @order }
    end
  end

  def new
    @gift     = Gift.find(params[:id])
    @redeem   = @gift.redeem
    @provider = @gift.provider
    
    if @redeem
      @order = Order.new(redeem_id: @redeem.id, gift_id: @gift.id, server_id: current_user.id, provider_id: @provider.id)
    else
      # no redeem = no order possible
      @order = Order.new
    end



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order    = Order.new(params[:order])
            # trigger : true for user side
            #         : false for merchant side
    trigger   = @order.redeem_code.nil? ? true : false

    respond_to do |format|
      if @order.save
        if trigger
          format.html { redirect_to completed_gift_path(@order), notice: 'Order is Completed. Thank You!' }
        else
          format.html { redirect_to completed_merchant_path(@order), notice: 'Order is Completed. Thank You!' }
        end
        format.json { render json: @order, status: :created, location: @order }
      else
        if trigger
          format.html { redirect_to @order.redeem, notice: "Drink not authorized. Server Code incorrect." }
        else
          format.html { redirect_to order_merchant_path(@order.gift_id), notice: "Drink not authorized. Redeem Code incorrect." }
        end
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end

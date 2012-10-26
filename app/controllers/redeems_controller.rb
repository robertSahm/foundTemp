class RedeemsController < ApplicationController

  def index
    @redeems = Redeem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @redeems }
    end
  end

  def show
    @redeem   = Redeem.find(params[:id])
    @gift     = @redeem.gift
    @giver    = @redeem.giver
    provider  = @redeem.provider
    @server_codes = provider.server_codes
    @servers  = provider.get_servers
    @order = Order.new(redeem_id: @redeem.id, gift_id: @gift.id, provider_id: provider.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @redeem }
    end
  end

  def new
    #@gift = Gift.find(params[:gift_id])
    @gift = Gift.new
    @redeem = Redeem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @redeem }
    end
  end

  def edit
    @redeem = Redeem.find(params[:id])
  end

  def create
    gift_id = params[:gift_id]
    if @redeem = Redeem.find_by_gift_id(gift_id)
      notice = nil
    else
      @redeem = Redeem.new(gift_id: gift_id)
      notice  = 'Give the code in blue to your server or user the server code by clicking merchant redeem below'
    end
    respond_to do |format|
      if @redeem.save
        if notice
          format.html { redirect_to @redeem, notice: notice }
        else
          format.html { redirect_to @redeem }
        end
        format.json { render json: @redeem, status: :created, location: @redeem }
      else
        format.html { render action: "new" }
        format.json { render json: @redeem.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @redeem = Redeem.find(params[:id])

    respond_to do |format|
      if @redeem.update_attributes(params[:redeem])
        format.html { redirect_to @redeem, notice: 'Redeem was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @redeem.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @redeem = Redeem.find(params[:id])
    @redeem.destroy

    respond_to do |format|
      format.html { redirect_to redeems_url }
      format.json { head :no_content }
    end
  end
end

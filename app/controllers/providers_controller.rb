class ProvidersController < ApplicationController

  def index
    @providers = Provider.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @providers }
    end
  end

  def show
    @provider = Provider.find(params[:id])
    @menu = create_menu_from_items(@provider)
    @gifts = Gift.get_activity_at_provider(@provider)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provider }
    end
  end

  def new
    @provider = Provider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provider }
    end
  end

  def edit
    @provider = Provider.find(params[:id])
  end

  def create
    super_user = current_user
    @provider = Provider.new(params[:provider])
    @provider.users = [super_user]

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: 'Provider was successfully created.' }
        format.json { render json: @provider, status: :created, location: @provider }
      else
        format.html { render action: "new" }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @provider = Provider.find(params[:id])

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        format.html { redirect_to @provider, notice: 'Provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @provider = Provider.find(params[:id])
    @provider.destroy

    respond_to do |format|
      format.html { redirect_to providers_url }
      format.json { head :no_content }
    end
  end
end

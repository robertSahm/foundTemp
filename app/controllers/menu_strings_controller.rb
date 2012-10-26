class MenuStringsController < ApplicationController

  def index
    @menu_strings = MenuString.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @menu_strings }
    end
  end

  def show
    @menu_string = MenuString.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @menu_string }
    end
  end

  def new
    @menu_string = MenuString.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @menu_string }
    end
  end

  def edit
    @menu_string = MenuString.find(params[:id])
  end

  def create
    @menu_string = MenuString.new(params[:menu_string])

    respond_to do |format|
      if @menu_string.save
        format.html { redirect_to @menu_string, notice: 'Menu string was successfully created.' }
        format.json { render json: @menu_string, status: :created, location: @menu_string }
      else
        format.html { render action: "new" }
        format.json { render json: @menu_string.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @menu_string = MenuString.find(params[:id])

    respond_to do |format|
      if @menu_string.update_attributes(params[:menu_string])
        format.html { redirect_to @menu_string, notice: 'Menu string was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @menu_string.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @menu_string = MenuString.find(params[:id])
    @menu_string.destroy

    respond_to do |format|
      format.html { redirect_to menu_strings_url }
      format.json { head :no_content }
    end
  end
end

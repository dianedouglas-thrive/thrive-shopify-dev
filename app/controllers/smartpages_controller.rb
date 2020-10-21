class SmartpagesController < ApplicationController
  before_action :set_smartpage, only: [:show, :edit, :update, :destroy]

  # GET /smartpages
  # GET /smartpages.json
  def index
    @smartpages = Smartpage.all
  end

  # GET /smartpages/1
  # GET /smartpages/1.json
  def show
  end

  # GET /smartpages/new
  def new
    @smartpage = Smartpage.new
  end

  # GET /smartpages/1/edit
  def edit
  end

  # POST /smartpages
  # POST /smartpages.json
  def create
    @smartpage = Smartpage.new(smartpage_params)
    @shop = Shop.where(id: session['shop_id']).first
    @smartpage.shop_id = @shop.id if @shop

    respond_to do |format|
      if @shop && @smartpage.save
        format.html { redirect_to @smartpage, notice: 'Smartpage was successfully created.' }
        format.json { render :show, status: :created, location: @smartpage }
      else
        format.html { render :new }
        format.json { render json: @smartpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /smartpages/1
  # PATCH/PUT /smartpages/1.json
  def update
    respond_to do |format|
      if @smartpage.update(smartpage_params)
        format.html { redirect_to @smartpage, notice: 'Smartpage was successfully updated.' }
        format.json { render :show, status: :ok, location: @smartpage }
      else
        format.html { render :edit }
        format.json { render json: @smartpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /smartpages/1
  # DELETE /smartpages/1.json
  def destroy
    @smartpage.destroy
    respond_to do |format|
      format.html { redirect_to smartpages_url, notice: 'Smartpage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_smartpage
      @smartpage = Smartpage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def smartpage_params
      params.require(:smartpage).permit(:path)
    end
end

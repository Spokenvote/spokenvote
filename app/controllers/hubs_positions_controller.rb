class HubsPositionsController < ApplicationController
  # GET /hubs_positions
  # GET /hubs_positions.json
  def index
    @hubs_positions = HubsPosition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hubs_positions }
    end
  end

  # GET /hubs_positions/1
  # GET /hubs_positions/1.json
  def show
    @hubs_position = HubsPosition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hubs_position }
    end
  end

  # GET /hubs_positions/new
  # GET /hubs_positions/new.json
  def new
    @hubs_position = HubsPosition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hubs_position }
    end
  end

  # GET /hubs_positions/1/edit
  def edit
    @hubs_position = HubsPosition.find(params[:id])
  end

  # POST /hubs_positions
  # POST /hubs_positions.json
  def create
    @hubs_position = HubsPosition.new(params[:hubs_position])

    respond_to do |format|
      if @hubs_position.save
        format.html { redirect_to @hubs_position, notice: 'Governing bodies position was successfully created.' }
        format.json { render json: @hubs_position, status: :created, location: @hubs_position }
      else
        format.html { render action: "new" }
        format.json { render json: @hubs_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hubs_positions/1
  # PUT /hubs_positions/1.json
  def update
    @hubs_position = HubsPosition.find(params[:id])

    respond_to do |format|
      if @hubs_position.update_attributes(params[:hubs_position])
        format.html { redirect_to @hubs_position, notice: 'Governing bodies position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hubs_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hubs_positions/1
  # DELETE /hubs_positions/1.json
  def destroy
    @hubs_position = HubsPosition.find(params[:id])
    @hubs_position.destroy

    respond_to do |format|
      format.html { redirect_to hubs_positions_url }
      format.json { head :no_content }
    end
  end
end

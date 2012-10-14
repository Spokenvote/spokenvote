class GoverningBodiesPositionsController < ApplicationController
  # GET /governing_bodies_positions
  # GET /governing_bodies_positions.json
  def index
    @governing_bodies_positions = GoverningBodiesPosition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @governing_bodies_positions }
    end
  end

  # GET /governing_bodies_positions/1
  # GET /governing_bodies_positions/1.json
  def show
    @governing_bodies_position = GoverningBodiesPosition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @governing_bodies_position }
    end
  end

  # GET /governing_bodies_positions/new
  # GET /governing_bodies_positions/new.json
  def new
    @governing_bodies_position = GoverningBodiesPosition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @governing_bodies_position }
    end
  end

  # GET /governing_bodies_positions/1/edit
  def edit
    @governing_bodies_position = GoverningBodiesPosition.find(params[:id])
  end

  # POST /governing_bodies_positions
  # POST /governing_bodies_positions.json
  def create
    @governing_bodies_position = GoverningBodiesPosition.new(params[:governing_bodies_position])

    respond_to do |format|
      if @governing_bodies_position.save
        format.html { redirect_to @governing_bodies_position, notice: 'Governing bodies position was successfully created.' }
        format.json { render json: @governing_bodies_position, status: :created, location: @governing_bodies_position }
      else
        format.html { render action: "new" }
        format.json { render json: @governing_bodies_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /governing_bodies_positions/1
  # PUT /governing_bodies_positions/1.json
  def update
    @governing_bodies_position = GoverningBodiesPosition.find(params[:id])

    respond_to do |format|
      if @governing_bodies_position.update_attributes(params[:governing_bodies_position])
        format.html { redirect_to @governing_bodies_position, notice: 'Governing bodies position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @governing_bodies_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /governing_bodies_positions/1
  # DELETE /governing_bodies_positions/1.json
  def destroy
    @governing_bodies_position = GoverningBodiesPosition.find(params[:id])
    @governing_bodies_position.destroy

    respond_to do |format|
      format.html { redirect_to governing_bodies_positions_url }
      format.json { head :no_content }
    end
  end
end

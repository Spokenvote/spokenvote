class GoverningBodiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :homepage]

  def homepage
    @governing_bodies = GoverningBody.by_name

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @governing_bodies_positions }
    end
  end

  # GET /governing_bodies
  # GET /governing_bodies.json
  def index
    @governing_bodies = GoverningBody.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @governing_bodies }
    end
  end

  # GET /governing_bodies/1
  # GET /governing_bodies/1.json
  def show
    @governing_body = GoverningBody.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @governing_body }
    end
  end

  # GET /governing_bodies/new
  # GET /governing_bodies/new.json
  def new
    @governing_body = GoverningBody.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @governing_body }
    end
  end

  # GET /governing_bodies/1/edit
  def edit
    @governing_body = GoverningBody.find(params[:id])
  end

  # POST /governing_bodies
  # POST /governing_bodies.json
  def create
    @governing_body = GoverningBody.new(params[:governing_body])

    respond_to do |format|
      if @governing_body.save
        format.html { redirect_to @governing_body, notice: 'Governing body was successfully created.' }
        format.json { render json: @governing_body, status: :created, location: @governing_body }
      else
        format.html { render action: "new" }
        format.json { render json: @governing_body.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /governing_bodies/1
  # PUT /governing_bodies/1.json
  def update
    @governing_body = GoverningBody.find(params[:id])

    respond_to do |format|
      if @governing_body.update_attributes(params[:governing_body])
        format.html { redirect_to @governing_body, notice: 'Governing body was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @governing_body.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /governing_bodies/1
  # DELETE /governing_bodies/1.json
  def destroy
    @governing_body = GoverningBody.find(params[:id])
    @governing_body.destroy

    respond_to do |format|
      format.html { redirect_to governing_bodies_url }
      format.json { head :no_content }
    end
  end
end

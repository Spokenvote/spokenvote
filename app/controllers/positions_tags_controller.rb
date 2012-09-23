
class PositionsTagsController < ApplicationController
  # GET /positions_tags
  # GET /positions_tags.json
  def index
    @positions_tags = PositionsTag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @positions_tags }
    end
  end

  # GET /positions_tags/1
  # GET /positions_tags/1.json
  def show
    @positions_tag = PositionsTag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @positions_tag }
    end
  end

  # GET /positions_tags/new
  # GET /positions_tags/new.json
  def new
    @positions_tag = PositionsTag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @positions_tag }
    end
  end

  # GET /positions_tags/1/edit
  def edit
    @positions_tag = PositionsTag.find(params[:id])
  end

  # POST /positions_tags
  # POST /positions_tags.json
  def create
    @positions_tag = PositionsTag.new(params[:positions_tag])

    respond_to do |format|
      if @positions_tag.save
        format.html { redirect_to @positions_tag, notice: 'Positions tag was successfully created.' }
        format.json { render json: @positions_tag, status: :created, location: @positions_tag }
      else
        format.html { render action: "new" }
        format.json { render json: @positions_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /positions_tags/1
  # PUT /positions_tags/1.json
  def update
    @positions_tag = PositionsTag.find(params[:id])

    respond_to do |format|
      if @positions_tag.update_attributes(params[:positions_tag])
        format.html { redirect_to @positions_tag, notice: 'Positions tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @positions_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions_tags/1
  # DELETE /positions_tags/1.json
  def destroy
    @positions_tag = PositionsTag.find(params[:id])
    @positions_tag.destroy

    respond_to do |format|
      format.html { redirect_to positions_tags_url }
      format.json { head :no_content }
    end
  end
end

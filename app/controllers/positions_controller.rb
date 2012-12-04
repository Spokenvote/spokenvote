class PositionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.by_governing_body #current_user.positions.select(&:is_root?)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
    context = params[:context]

    if context
      position_id = context.split("_")[1].split(":")[1]
      page_number = (context.split("_")[0].split(":")[1]).to_i

      records_limit = 10
      position = Position.find(position_id)
      votes = position.votes.limit(records_limit).offset(page_number * records_limit + 2)
      render :partial => 'position_vote', :collection => votes, :as => :vote
    else
      page_number = params[:page_number]
      @position = Position.find(params[:id])
      @votes = @position.votes.limit(10 * page_number.to_i + 2)
      @total_votes = @position.root.descendants.count

      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @position }
      end
    end
  end

  # GET /positions/new
  # GET /positions/new.json
  def new
    @position = Position.new
    @parent_position = Position.find(params[:parent_id]) if params[:parent_id]
    @vote = @position.votes.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.json
  def create
    governing_body = GoverningBody.find(params[:governing_id])
    votes = params[:position].delete :votes_attributes
    @position = governing_body.positions.create(params[:position])
    
    # TODO THIS IS HORRIBLE
    @position.votes.create votes['0']
    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: 'Position was successfully created.' }
        format.json { render json: @position, status: :created, location: @position }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.json
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end
end

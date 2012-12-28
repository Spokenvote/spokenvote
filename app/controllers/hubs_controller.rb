class HubsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :homepage]

  def homepage
    @searched = ''
    if params[:hub]
      @search_hubs = Hub.where({name: params[:hub]})
      @searched = params[:hub]
      @proposals = Proposal.joins(:hubs).where({:hubs => {:id => @search_hubs.first.id}}).uniq(:ancestry).order('votes_count DESC')
    # elsif params[:city]
    #   @search_hubs = Hub.where({location: params[:city]})
    #   @searched = params[:city]
    #   @proposals = ... matching Proposals query
    # elseif <other searchable things>
    #   ...
    else
      @proposals = Proposal.order('votes_count DESC').limit(5)
    end
    @hubs = Hub.by_name
    @user_proposals = current_user.proposals.order('votes_count DESC') if current_user

    respond_to do |format|
      format.html
      format.json { render json: @user_proposals }
    end
  end

  # GET /hubs
  # GET /hubs.json
  def index
    if params[:hub]
      @hubs = Hub.where({name: params[:hub]})
    # elsif params[:city]
    #   @hubs = Hub.where({name: params[:hub]})
    else
      @hubs = Hub.all#Hub.by_proposal_count
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hubs }
    end
  end

  # GET /hubs/1
  # GET /hubs/1.json
  def show
    @hub = Hub.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hub }
    end
  end

  # GET /hubs/new
  # GET /hubs/new.json
  def new
    @hub = Hub.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hub }
    end
  end

  # GET /hubs/1/edit
  def edit
    @hub = Hub.find(params[:id])
  end

  # POST /hubs
  # POST /hubs.json
  def create
    @hub = Hub.new(params[:hub])

    respond_to do |format|
      if @hub.save
        format.html { redirect_to @hub, notice: 'Hub was successfully created.' }
        format.json { render json: @hub, status: :created, location: @hub }
      else
        format.html { render action: "new" }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hubs/1
  # PUT /hubs/1.json
  def update
    @hub = Hub.find(params[:id])

    respond_to do |format|
      if @hub.update_attributes(params[:hub])
        format.html { redirect_to @hub, notice: 'Hub was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hubs/1
  # DELETE /hubs/1.json
  def destroy
    @hub = Hub.find(params[:id])
    @hub.destroy

    respond_to do |format|
      format.html { redirect_to hubs_url }
      format.json { head :no_content }
    end
  end
end

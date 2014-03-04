class HubsController < ApplicationController
  before_action :authenticate_user!, :except => [:show, :index, :homepage]

  # GET /hubs
  # GET /hubs.json
  def index
    hub_filter, location_id_filter = params[:hub_filter], params[:location_id_filter]

    if hub_filter.presence && location_id_filter.presence
      @hubs = Hub.where('group_name ilike ? AND formatted_location = ?', "%#{hub_filter}%", location_id_filter)
    elsif hub_filter.presence
      @hubs = Hub.where('formatted_location ilike ? or group_name ilike ?', "%#{hub_filter}%", "%#{hub_filter}%")
    elsif location_id_filter.presence
      @hubs = Hub.where('location_id = ?', location_id_filter)
    else
      @hubs = Hub.all
    end

    found_hubs = @hubs.map { |h| "#{h.group_name} #{h.formatted_location}" }

    # Add google place matches to list of hubs if they dont already exist in our DB
    if hub_filter.presence 
      begin 
        service = GooglePlacesAutocompleteService.new
        service.find_regions(hub_filter).each do |l|
          if !found_hubs.include?("#{l[:type]} #{l[:description]}")
            new_hub = Hub.new(group_name: l[:type], location_id: l[:id], formatted_location: l[:description], description: l[:reference])
            new_hub.id = 0
            @hubs << new_hub
          end
        end
      rescue ArgumentError 
        pp "WARNING: Could not use google service to find hubs"
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hubs.to_json(:methods => [:full_hub, :short_hub, :select_id]) }
    end
  end

  # GET /hubs/1
  # GET /hubs/1.json
  def show
    if params[:id].starts_with?(GooglePlacesAutocompleteService.prefix) 
      hub_id = params[:id][3..-1]
      @hub = Hub.find_by_description(hub_id)
      if !@hub 
        begin 
          service = GooglePlacesAutocompleteService.new
          found_hub = service.get_place_details(hub_id)
          if found_hub
            @hub = Hub.new(group_name: found_hub[:type], location_id: found_hub[:id], formatted_location: found_hub[:description], description: found_hub[:reference])
            @hub.id = 0
          else
            @hub = {}
          end
        rescue ArgumentError 
          pp "WARNING: Could not use google service to find hub details"
        end
      end
    else 
      @hub = Hub.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hub.to_json(:methods => [:full_hub, :short_hub, :select_id]) }
    end
  end

  # GET /hubs/new
  # GET /hubs/new.json
  def new
    @hub = Hub.new
    if params[:requested_group].presence
      @hub.group_name = params[:requested_group]
    end

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
        format.json { render json: @hub, status: :ok }
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

class HubsController < ApplicationController
  before_action :authenticate_user!, :except => [:show, :index, :homepage]

  # GET /hubs
  # GET /hubs.json
  def index
    hub_filter, location_id_filter = params[:hub_filter], params[:location_id_filter]

    filter_hubs(hub_filter, location_id_filter)

    found_hubs = @hubs.map { |h| h.attributes.slice(:group_name, :formatted_location) }

    # Add google place matches to list of hubs if they dont already exist in our DB
    if hub_filter.presence 
      begin
        GooglePlacesAutocompleteService.new.find_regions(hub_filter).each do |l|
          unless found_hubs.include?(group_name: l[:type], formatted_location: l[:description])
            new_hub = Hub.new(group_name: l[:type], location_id: l[:id], formatted_location: l[:description], description: l[:reference])
            new_hub.id = 0
            @hubs << new_hub
          end
        end
      rescue ArgumentError => e
        Rails.logger.error "WARNING: Could not use google service to find hubs. Error: #{e.message}"
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hubs.to_json(methods: [:full_hub, :short_hub, :select_id]) }
    end
  end

  # GET /hubs/1
  # GET /hubs/1.json
  def show
    if params[:id].starts_with?(GooglePlacesAutocompleteService.prefix)
      hub_id = params[:id].sub(GooglePlacesAutocompleteService.prefix, '')
      @hub = Hub.find_by_description(hub_id)
      unless hub.present?
        begin
          found_hub = GooglePlacesAutocompleteService.new.get_place_details(hub_id)
          if found_hub
            @hub = Hub.new(group_name: found_hub[:type], location_id: found_hub[:id], formatted_location: found_hub[:description], description: found_hub[:reference])
            @hub.id = 0
          else
            @hub = {}
          end
        rescue ArgumentError => e
          pp "WARNING: Could not use google service to find hub details. Error: #{e.message}"
        end
      end
    else
      @hub = Hub.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hub.to_json(methods: [:full_hub, :short_hub, :select_id]) }
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
        format.html { redirect_to @hub, noutice: 'Hub was successfully updated.' }
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

  private

  def filter_hubs(hub_filter, location_id_filter)
    @hubs = Hub.all
    if hub_filter.presence && location_id_filter.presence
      @hubs = @hubs.where('group_name ilike ?', "%#{hub_filter}%").where(formatted_location: location_id_filter)
    elsif hub_filter.presence
      @hubs = @hubs.where('formatted_location ilike ? OR group_name ilike ?', "%#{hub_filter}%", "%#{hub_filter}%")
    elsif location_id_filter.presence
      @hubs = @hubs.where(location_id: location_id_filter)
    end

    @hubs
  end
end

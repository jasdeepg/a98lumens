class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :user_inst_data, :sandbox]

  # test new dashboard functionality with sample profile
  def sandbox
    @user = User.find(1)

    client = Weatherman::Client.new

    @potential_trees = (463000*0.00069)*0.08 - @user.calculate_overall_trees_for;
    @potential_cars = (463000*0.00069)/4200 - @user.calculate_overall_cars_for;

    if !@user.panel_zip.nil?
      response = client.lookup_by_woeid(lookup_woeid(@user.panel_zip))

      @weather = response.description
      @weather = clean_forecast(@weather).html_safe
      city = response.location['city']
      state = response.location['region']
      @location = [city, state].join(',')
    end

    puts @user.energy_data.nil?
    if @user.energy_data.first.nil?
      puts "pass"
    else
      @energy_data = @user.energy_data.order("created_at DESC").limit(10)
      @dayTotals = @user.consolidate_day
      @days, @weekTotals = @user.consolidate_week
      @monthTotals = @user.monthSum

      #totals
      @weekPowerTotal = @user.calculate_week_power_for
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    @this_user = User.find(1)

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

      client = Weatherman::Client.new

      if !@user.panel_zip.nil?
        response = client.lookup_by_woeid(lookup_woeid(@user.panel_zip))

        @weather = response.description
        @weather = clean_forecast(@weather).html_safe
        city = response.location['city']
        state = response.location['region']
        @location = [city, state].join(',')
     end

      puts @user.energy_data.nil?
      if @user.energy_data.first.nil?
        puts "pass"
      else
        @energy_data = @user.energy_data.order("created_at DESC").limit(10)
        @dayTotals = @user.consolidate_day
        @days, @weekTotals = @user.consolidate_week
        @monthTotals = @user.monthSum

        #totals
        @weekPowerTotal = @user.calculate_week_power_for
      end

      respond_to do |format|
        format.html # show.html.erb
        format.js
        format.json { render json: @user }
      end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Welcome to the 98Lumens family!' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # present data to grab for view work
  # get/user_data
  def user_inst_data
    timestamp = params[:time_now]
    user_id = params[:user_id]

    before = fetch_data_at_time(user_id, timestamp)
    after = fetch_data_at_time(user_id, (timestamp.to_i+3600))

    response = Hash.new

    response['before'] = before
    response['after'] = after

    render json: response.to_json
  end

  private
    def clean_forecast(forecast)
      forecast_sep = forecast.split("\n");
      new_forecast = forecast_sep[0..3].join()
    end

    def lookup_woeid(zip)
      woeid_cities = {"93706" => "2407517"}

      woeid_cities[zip].to_i
    end

    def current_user?(user)
      if current_user=user
        true
      else
        false
      end
    end

    def fetch_data_at_time(user_id, time_at)
      # convert time to object
      timestamp = Time.zone.at(time_at.to_i)
      # break down timestamp right now
      year = timestamp.year
      month = timestamp.month
      day = timestamp.day
      hour = timestamp.hour+1 #we're 1-indexed

      # find data
      response = EnergyDatum.where(:user_id=>user_id, :year=>year, :month=>month, :day=>day, :hour=>hour).select('power')
      
      #response = response(:include=> :power)

      #@response_list = r

      return response
    end
end

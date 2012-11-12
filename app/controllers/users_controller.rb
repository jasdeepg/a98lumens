class UsersController < ApplicationController
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

      #green console
      @em_monthTotals = @user.em_monthTotals
      @em_weekTotals = @user.em_weekTotals
      @em_dayTotals = @user.em_dayTotals

      #finance console
      @fi_monthTotals = @user.fi_monthTotals
      @fi_weekTotals = @user.fi_weekTotals
      @fi_dayTotals = @user.fi_dayTotals
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

  private
    def clean_forecast(forecast)
      forecast_sep = forecast.split("\n");
      new_forecast = forecast_sep[0..3].join()
    end

    def lookup_woeid(zip)
      woeid_cities = {"93706" => "2407517"}

      woeid_cities[zip].to_i
    end
      
end

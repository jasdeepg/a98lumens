class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def test
	
  end

  def state_retail_price
  	api_key = "8E696ED2EE7577B35204C9FE451B367C"
  	state_id = params[:state]

  	targetURL = 'http://api.eia.gov/series/data/?api_key='+api_key+"&series_id=ELEC.PRICE."+state_id+"-RES.A"

  	handle_to_target = open(targetURL)

  	parsed_json = ActiveSupport::JSON.decode(handle_to_target)

  	@response = parsed_json

  	render json: @response
  end

end

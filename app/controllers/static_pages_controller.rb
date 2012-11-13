class StaticPagesController < ApplicationController
    layout "override"

  def home
  end

  def about
  end

  def benefits
  end

  def test
  end

  def learn
  end

  def faqs
  end

  def consult
  end

  def contact
    @snippet = fetch_url('http://98lumens.com/contact.html').html_safe
  end

  def projects
  end

  def info_mail
    @name = params[:name]
    @company = params[:company]
    @phone = params[:phone]
    @email = params[:email]
    @message = params[:message]

    UserMailer.info_mail(@name,@company,@phone,@email,@message).deliver

    respond_to do |format|
      format.html {redirect_to contact_path, notice: 'Thanks for your message!'}
    end
  end

  def submit_reserve
      @name = params[:name]
      @panels = params[:panels]
      @phone = params[:phone]
      @email = params[:email]
      @message = params[:message]

      UserMailer.reservation_mail(@name,@panels,@phone,@email,@message).deliver
      UserMailer.internal_reserve(@name,@panels,@phone,@email,@message).deliver

      # @name=$_POST['name'];
      # @panels=$_POST['panels'];
      # @phone=$_POST['phone'];
      # @email=$_POST['email'];
      # @message=$_POST['message'];

      # $to='chirath@98lumens.com';

      # $headers = 'From: '.$name."\r\n" .
      #   'Reply-To: '.$email."\r\n" .
      #   'X-Mailer: PHP/' . phpversion();
      # $subject = 'Message from 98lumens website';
      # $body='You have got a new reservation from your website - 98lumens.'."\n\n";

      # $body.='Full name: '.$name."\n";
      # $body.='Number of solar panels: '.$panels."\n";
      # $body.='Telephone Number: '.$phone."\n";
      # $body.='Email: '.$email."\n";
      # $body.='Message: '."\n".$message."\n";
        
      # if(mail($to, $subject, $body, $headers)) {
      #   die('Thank you for reserving your solar panels with 98lumens. Reservation complete.');
      # } else {
      #   die('Error: Apologies, Please contact sales@98lumens.com');
      # }

      respond_to do |format|
        format.html {redirect_to contact_path, notice: 'Thanks for your reservation! 
        You\'re all set. We\'ll get back to you as soon as possible.'}
      end
  end

  def reserve
    @userPanels = params[:UserPanels]
    @setPanels = params[:SetPanels]
  end

  def pricing
    @userPanels = params[:UserPanels]   
    @setPanels = params[:SetPanels]

    electricCoeff = 43;
    productionCoeff = 500;
    panelLifeTime = 25;
    cO2Coeff = 0.68956;
    treeCoeff = 80;
    vehicleCoeff = 5.1;

    @lumensPanelPrice = 799;
    @homePanelPrice = 1000;
    @lumensinterest = 3.5;
    @homeinterest = 3.0;
    savingsinterest = 0.5;

    electricityUse = @userPanels * electricCoeff;
    lifetimeUse = electricityUse * panelLifeTime * 12;
    cO2emissions = lifetimeUse*((cO2Coeff.to_f)/1000);
    cO2emissionsPerYear = (cO2emissions.to_f)/(panelLifeTime.to_i);
    percentOffset = (@setPanels.to_i)/((@userPanels.to_i)*100);

    @lifetimeProduction = (productionCoeff.to_f)*(@setPanels.to_i)*(panelLifeTime.to_i);
    @annualProduction = @lifetimeProduction / panelLifeTime;
    @cO2Offset = @lifetimeProduction * cO2Coeff / 1000;
    cO2OffsetPerYear = @cO2Offset / panelLifeTime;
    @plantedTrees = @cO2Offset * treeCoeff;
    vehicleOffset = @cO2Offset * vehicleCoeff;

    @lumensPrice = (@setPanels.to_i)*(@lumensPanelPrice.to_i);    
    @homePrice = (@setPanels.to_i)*(@homePanelPrice.to_i);

    @lumensLifeReturns = @lumensPrice + (@lumensPrice * ((@lumensinterest.to_f)/100) * panelLifeTime);
    @homeLifeReturns = @homePrice + (@homePrice * ((@homeinterest.to_f)/100) * panelLifeTime);
    @savingsLifeReturns = @lumensPrice + (@lumensPrice * ((savingsinterest.to_f)/100) * panelLifeTime);

    @lumensAnnualReturns = (@lumensLifeReturns.to_f)/(panelLifeTime.to_i);
    @savingsAnnualReturns = @lumensPrice*((savingsinterest.to_f)/100);
  end

  def calculator
      @userPanels = params[:UserPanels]   
      @setPanels = params[:SetPanels]

      @percentOffset, @cO2Offset, 
        @cO2OffsetPerYear, @plantedTrees, 
          @vehicleOffset, @lifetimeProduction,
            @electricityUse, @cO2emissionsPerYear = do_calculations(@userPanels, @setPanels)
  end

  def state_retail_price
  	api_key = "8e696eD2ee7577B35204C9Fe451B367C"
  	state_id = params[:state]

  	targetURL = 'http://api.eia.gov/series/data/?api_key='+api_key+"&series_id=eLeC.PRICe."+state_id+"-ReS.A"

  	handle_to_target = open(targetURL)

  	parsed_json = ActiveSupport::JSON.decode(handle_to_target)

  	@response = parsed_json

  	render json: @response
  end

  private
    def do_calculations(userPanels_pass, setPanels_pass)
      userPanels = userPanels_pass
      setPanels = setPanels_pass

      electricCoeff = 43
      productionCoeff = 500
      panelLifeTime = 25
      
      cO2Coeff = 0.68956
      treeCoeff = 80
      vehicleCoeff = 5.1

      electricityUse = (userPanels.to_i)*(electricCoeff.to_f)
      lifetimeUse = electricityUse * panelLifeTime * 12
      cO2emissions = lifetimeUse*((cO2Coeff.to_f)/1000)
      cO2emissionsPerYear = (cO2emissions.to_f)/panelLifeTime
      
      percentOffset = ((productionCoeff.to_f)*(setPanels.to_i))/(electricityUse*12)

      lifetimeProduction = (productionCoeff.to_f)*(setPanels.to_i)*(panelLifeTime.to_i)
      cO2Offset = lifetimeProduction * cO2Coeff.to_f/1000
      cO2OffsetPerYear = cO2Offset/panelLifeTime
      plantedTrees = cO2Offset * treeCoeff
      vehicleOffset = cO2Offset * vehicleCoeff

      return percentOffset, cO2Offset, cO2OffsetPerYear, plantedTrees, vehicleOffset, lifetimeProduction, electricityUse, cO2emissionsPerYear
    end

    def fetch_url(url)
      require 'net/http'

      r = Net::HTTP.get_response( URI.parse( url ) )
      if r.is_a? Net::HTTPSuccess
        r.body
      else
        nil
      end
    end

end

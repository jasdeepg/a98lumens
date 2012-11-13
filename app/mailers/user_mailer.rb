class UserMailer < ActionMailer::Base
  default :to => "jasdeepsgarcha@gmail.com", :from => "jas@98lumens.com"

   def reservation_mail(name,panels,phone,email,message)
    @name = name
    @panels = panels
    @phone = phone
    @email = email
    @message = message

    @url  = "http://www.98lumens.com"
    mail(:to => email, :subject => "Thanks for your reservation")
  end

  def info_mail(name,company,phone,email,message)
    @name = name
    @company = company
    @phone = phone
    @email = email
    @message = message

    @url  = "http://www.98lumens.com"
    mail(:to => email, :subject => "Thanks for your reservation")
  end


end

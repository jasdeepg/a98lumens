# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
A98lumens::Application.initialize!

A98lumens::Application.configure do

	config.action_mailer.delivery_method = :smtp

	ActionMailer::Base.smtp_settings = {
	  :address  => "smtp.gmail.com",
	  :port  => 587,
	  :domain => "smtp.gmail.com",
	  :user_name  => "jas@98lumens.com",
	  :password  => "password",
	  :authentication  => :login
	}

	config.action_mailer.raise_delivery_errors = true

end
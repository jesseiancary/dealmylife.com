class UserMailer < ActionMailer::Base
  
  default from: "info@dealmylife.com"
 
  def welcome_email user
    @user = user
    @url  = "http://dealmylife.com/account/login"
    mail :to => user.email, :subject => "Welcome to My Awesome Site"
  end
 
  def reset_password_email user, password
    @user = user
    @password = password
    @url  = "http://dealmylife.com/account/login"
    mail :to => user.email, :subject => "Welcome to My Awesome Site"
  end
  
end

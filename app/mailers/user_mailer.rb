class UserMailer < ActionMailer::Base
  default to: "dextrous90akash@gmail.com",
  				from: "er.akashkhandelwal@gmail.com"

  def registration_confirmation(user)
  	@user = user
  	attachments["rails.png"] = File.read("#{Rails.root}/public/Me.jpg")
  	mail(to: "#{user.email} <#{user.email}>", subject: "Confirm Registration")
  end

  def password_reset(user)
  	@user = user
  	mail(to: user.email, subject: "Password Reset")
  end
end

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "railscasts.com",
  :user_name            => "er.akashkhandelwal@gmail.com",
  :password             => "9829496376",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
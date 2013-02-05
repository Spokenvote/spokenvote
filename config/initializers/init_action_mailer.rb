ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.smtp_settings = {
  :address        => ENV['MAIL_ADDRESS'],
  :port           => ENV['MAIL_PORT'],
  :domain         => ENV['MAIL_DOMAIN'],
  :user_name      => ENV['MAIL_USERNAME'],
  :password       => ENV['MAIL_PASSWORD'],
  :authentication => :plain,
  :enable_starttls_auto => true
}
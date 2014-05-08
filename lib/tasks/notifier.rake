namespace :notify do
  desc "Update users on votes from the last x period"
  task daily: :environment do
    NotificationBuilder.organize_daily_email
  end
end
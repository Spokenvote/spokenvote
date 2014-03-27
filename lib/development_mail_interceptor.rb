class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = 'termmonitor@gmail.com' #Do we want to replace this with a shared email?
  end
end
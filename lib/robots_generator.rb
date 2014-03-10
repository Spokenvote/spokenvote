class RobotsGenerator
  # Use the config/robots.txt in production.
  # Disallow everything for all other environments.
  # http://avandamiri.com/2011/10/11/serving-different-robots-using-rack.html
  def self.call(env)
    body = if Rails.env.production?
             File.read Rails.root.join('config', 'robots.txt')
           else
             "User-agent: *\nDisallow: /"
           end

    # Heroku can cache content for free using Varnish.
    headers = { 'Cache-Control' => "public, max-age=#{1.month.seconds.to_i}" }

    [200, headers, [body]]
  rescue Errno::ENOENT
    [404, {}, ['# A robots.txt is not configured']]
  end
end
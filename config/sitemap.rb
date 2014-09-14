# Set the host name for URL creation
#SitemapGenerator::Sitemap.default_host = "http://www.example.com"
if ENV['RAILS_ENV'] == 'production'
  SitemapGenerator::Sitemap.default_host = "http://www.spokenvote.org"
else
  SitemapGenerator::Sitemap.default_host = "http://localhost:3000"
end

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  add '/', changefreq: 'daily', priority: 0.9
  add '/landing', changefreq: 'daily', priority: 0.9
  add '/user-forum', changefreq: 'daily', priority: 0.9
  add '/dev-forum', changefreq: 'daily', priority: 0.9
  add '/proposals?filter=recent', changefreq: 'daily', priority: 0.9
  add '/proposals?filter=active', changefreq: 'daily', priority: 0.9
  add '/terms-of-use', changefreq: 'monthly'
  add '/proposals', changefreq: 'daily', priority: 0.9
  Proposal.find_each do |proposal|
    add proposal_path(proposal), :lastmod => proposal.updated_at, priority: 0.7, changefreq: 'daily'
  end
end

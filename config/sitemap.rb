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

  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #

  # SEO Pages
  add '/group-consensus-tool', changefreq: 'daily', priority: 0.7
  add '/online-group-consensus-tool', changefreq: 'daily', priority: 0.7
  add '/voting-tool', changefreq: 'daily', priority: 0.7
  add '/reach-consensus', changefreq: 'daily', priority: 0.7
  add '/group-consensus', changefreq: 'daily', priority: 0.7

  # Nav Pages
  add '/', changefreq: 'daily', priority: 1.0
  add '/landing', changefreq: 'daily', priority: 1.0
  add '/dev-forum', changefreq: 'daily', priority: 0.7
  add '/user-forum', changefreq: 'daily', priority: 0.6
  add '/proposals', changefreq: 'daily', priority: 0.5
  add '/proposals?filter=recent', changefreq: 'daily', priority: 0.3
  add '/proposals?filter=active', changefreq: 'daily', priority: 0.3
  add '/terms-of-use', changefreq: 'monthly', priority: 0.2

  Proposal.find_each do |proposal|
    add proposal_path(proposal), :lastmod => proposal.updated_at, priority: 0.7, changefreq: 'daily'
  end
end

class SitemapsController < ApplicationController

  def show
    # Redirect to CloudFront and S3
    redirect_to "http://d1z6g7rr3s5nex.cloudfront.net/sitemaps/sitemap.xml.gz"
  end

end
class SitemapsController < ApplicationController

  def index
    # Redirect to CloudFront and S3
    p '---------> Sitemap served from CloudFront and S3'
    redirect_to SITEMAP_PATH
  end

end
class SitemapsController < ApplicationController
  skip_before_action :intercept_html_requests

  def index
    # Redirect to CloudFront and S3
    p '---------> Sitemap served from CloudFront and S3'
    redirect_to SITEMAP_PATH
  end

end
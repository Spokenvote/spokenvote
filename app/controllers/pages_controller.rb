class PagesController < ApplicationController
  def user_nav
    content = render_to_string partial: 'shared/navigation'
    render json: {success: true, content: content}
  end
end
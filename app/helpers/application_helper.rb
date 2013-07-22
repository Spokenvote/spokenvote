module ApplicationHelper
  def fb_button(btn_text)
  	content_tag(:span, '', class: "fb-button-left") +
  	content_tag(:span, content_tag(:strong, btn_text) + ' with ' + content_tag(:strong, 'Facebook'), class: "fb-button-center") +
  	content_tag(:span, '', class: "fb-button-right")
  end

  def items_count_badge(items, title_text = '')
    badge_class = 'badge'
    if items.between?(3,5)
      badge_class += ' badge-inverse'
    elsif items.between?(6,8)
      badge_class += ' badge-info'
    elsif items > 8
      badge_class += ' badge-success'
    end
    if title_text == ''
      content_tag(:div, items, :class => badge_class)
    else
      content_tag(:div, items, :class => badge_class, :title => title_text, :rel => 'tooltip')
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end

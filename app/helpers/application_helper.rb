module ApplicationHelper
  def fb_button(btn_text)
  	content_tag(:span, '', class: "fb-button-left") +
  	content_tag(:span, content_tag(:strong, btn_text) + ' with ' + content_tag(:strong, 'Facebook'), class: "fb-button-center") +
  	content_tag(:span, '', class: "fb-button-right")
  end

  def items_count_badge(items, title_text = '')
    badge_classes = ['badge']
    case
    when items.between?(3,5)
      badge_classes << 'badge-inverse'
    when items.between?(6,8)
      badge_classes << 'badge-info'
    when items > 8
      badge_classes << 'badge-success'
    end

    badge_class = badge_classes.join(' ')

    if title_text.empty?
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

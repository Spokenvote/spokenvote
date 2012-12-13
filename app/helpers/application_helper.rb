module ApplicationHelper
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
end

module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title='')
    base_title = "Rails Template"
    if page_title.nil? || page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def time_ago(time)
    "<time datetime=\"#{time.utc}\" title=\"#{time.strftime('%b %d, %Y %I:%M %p %Z')}\">#{time_ago_in_words(time)} ago</time>".html_safe
  end

end

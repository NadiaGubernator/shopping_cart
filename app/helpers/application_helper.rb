module ApplicationHelper
	def full_title(page_title = '')
    base_title = "Books Store"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def render_if(condition, record)
   if condition
      render record
    end
  end
end

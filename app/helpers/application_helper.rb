module ApplicationHelper
  def title
    base_title = "Magic Hat"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def header_back
    if @header_back
      link_to @header_back[:title], @header_back[:url], :class => "back"
    end
  end
end

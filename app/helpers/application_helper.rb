module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Book-It-Away"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def date_format(date)
    date.strftime("%b %d, %Y")
  end
  
  def rating_format(rating)
    rating.nil? ? "n/a" : number_with_precision(rating, precision: 1)
  end

end

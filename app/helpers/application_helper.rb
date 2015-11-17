module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = 'Book-It-Away'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def date_format(date)
    date.present? ? date.strftime('%b %d, %Y') : 'N/A'
  end
  
  def rating_format(rating)
    rating.present? ? number_with_precision(rating, precision: 1) : 'N/A'
  end
  
  def operator_html_options
    oper = ['<','=','>']
    str = String.new
    oper.each do |x|
      str = str + '<option>' + x + '</option>'
    end
    str = str.html_safe
  end
  
  def subject_html_options
    options = Subject.order('name ASC')
    str = String.new
    unless options.blank?
      options.each do |x|
        str = str + '<option>' + x.name + '</option>'
      end
    end
    str = str.html_safe
  end

end

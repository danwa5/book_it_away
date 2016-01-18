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

  def operator_html_options
    str = ''
    %w(< = >).each do |x|
      str = str + '<option>' + x + '</option>'
    end
    str.html_safe
  end

  def month_year_label(yyyymm)
    year = yyyymm[0..3]
    month_code = yyyymm[4..5].to_i
    Date::MONTHNAMES[month_code] + ' ' + year
  end
end

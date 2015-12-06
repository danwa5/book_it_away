class String
  def titleize_lastname
    humanize.gsub(/\b([a-z])/) { $1.capitalize }
  end
end
class String
  def titleize_lastname
    lastname = humanize.gsub(/\b([a-z])/) { $1.capitalize }
    lastname = lastname.camelize(:lower) if lastname.match(/De(l)?\s.+/)
    lastname
  end
end
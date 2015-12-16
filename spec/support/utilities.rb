def full_title(page_title)
  base_title = "Book-It-Away"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def sign_in(user, options={})
  visit signin_path
  fill_in('Email', with: user.email, match: :first)
  fill_in('Password', with: user.password, match: :first)
  click_button 'Sign In', match: :first
end
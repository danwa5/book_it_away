class UserMailer < ActionMailer::Base
  default :from => 'support@bookitaway.com'

  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Book-It-Away Registration Confirmation')
  end
end
require 'rails_helper'

describe 'Authentication' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Sign In') }
    it { should have_title('Sign In') }
  end
  
  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign In' }

      it { should have_title('Sign In') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe 'with valid information' do
      let(:user) { create(:user) }
      #before { sign_in user }
      before do
        fill_in 'Email',    with: user.email.upcase
        fill_in 'Password', with: user.password
        click_button 'Sign in'
      end

      it 'should redirect user to authors index page' do
        expect(current_path).to eq(authors_path)
      end
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }
      
      describe 'followed by signout' do
        before { first(:link, 'Sign out').click }
        it { should have_link('Sign In') }
      end
    end
  end
  
  describe 'authorization' do
    describe 'for signed-out user' do
      let(:user) { create(:user) }
      
      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in 'Email',    with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        describe 'after signing in' do
          it 'should render the desired protected page' do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe 'in the Users controller' do
        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end
        describe 'submitting to the update action' do
          before { patch user_path(user) }
          xit { expect(response).to redirect_to(signin_path) }
        end
        describe 'visiting the user index' do
          before { visit users_path }
          it { should have_title('Sign In') }
        end
      end
    end
    
    describe 'as wrong user' do
      let(:user) { create(:user) }
      let(:wrong_user) { create(:user, email: Faker::Internet.email) }
      before { sign_in user, no_capybara: true }

      describe 'submitting a GET request to the Users#edit action' do
        before { get edit_user_path(wrong_user) }
        xit { expect(response.body).not_to match(full_title('Edit user')) }
        xit { expect(response).to redirect_to(root_url) }
      end
      describe 'submitting a PATCH request to the Users#update action' do
        before { patch user_path(wrong_user) }
        xit { expect(response).to redirect_to(root_url) }
      end
    end
    
    describe 'as non-admin user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe 'submitting a DELETE request to the Users#destroy action' do
        before { delete user_path(user) }
        xit { expect(response).to redirect_to(root_url) }
      end
    end
  end
  
end

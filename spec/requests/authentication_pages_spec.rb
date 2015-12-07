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
      before { click_button 'Sign In', match: :first }

      it { is_expected.to have_title('Sign In') }
      it { is_expected.to have_selector('div.alert.alert-danger', text: 'Invalid email/password combination') }

      describe 'after visiting another page' do
        before { visit authors_path }
        it { is_expected.to have_selector('div.alert.alert-danger', text: 'Please sign in') }
      end
    end
    
    describe 'with valid information' do
      let(:user) { create(:user) }
      before { sign_in user }

      it 'should redirect user to authors index page' do
        expect(current_path).to eq(authors_path)
      end
      it { is_expected.to have_link('BLOG',     href: blog_path) }
      it { is_expected.to have_link('SETTINGS', href: user_path(user)) }
      it { is_expected.to have_link('SIGN OUT', href: signout_path) }
      
      describe 'followed by signout' do
        before { click_link('SIGN OUT') }
        it 'signs out user' do
          is_expected.to have_button('Sign In')
        end
        it 'redirects user if user tries to access private page' do
          visit authors_path
          expect(current_path).to eq(signin_path)
        end
      end
    end
  end
  
  describe 'authorization' do
    describe 'for signed-out user' do
      let(:user) { create(:user) }
      
      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in 'Email', with: user.email, match: :first
          fill_in 'Password', with: user.password, match: :first
          click_button 'Sign In', match: :first
        end

        describe 'after signing in' do
          it 'should render the desired protected page' do
            expect(page).to have_title('Update Account Settings')
          end
        end
      end

      describe 'in the Users controller' do
        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { is_expected.to have_title('Sign In') }
        end
        describe 'submitting to the update action' do
          before { patch user_path(user) }
          it { expect(response).to redirect_to(signin_path) }
        end
        describe 'visiting the user index' do
          before { visit users_path }
          it { is_expected.to have_title('Sign In') }
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

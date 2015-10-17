require 'spec_helper'

describe 'User pages' do

  subject { page }
  
  describe 'index' do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { is_expected.to have_title('All users') }
    it { is_expected.to have_content('All users') }

    describe 'pagination' do
      before(:all) { 30.times { create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.first_name + ' ' + user.last_name)
        end
      end
    end
    
    describe 'delete links' do
      it { should_not have_link('delete') }

      describe 'as an admin user' do
        let(:admin_user) { create(:admin_user) }
        before do
          sign_in admin_user
          visit users_path
        end

        it { is_expected.to have_link('delete', href: user_path(User.first)) }
        it 'should be able to delete another user' do
          expect {
            click_link('delete', match: :first)
          }.to change(User, :count).by(-1)
        end
        it { is_expected.to_not have_link('delete', href: user_path(admin_user)) }
      end
    end
  end
  
  describe 'profile page' do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end
    it { is_expected.to have_content('My Profile') }
    it { is_expected.to have_title(user.first_name + ' ' + user.last_name) }
  end

  describe 'signup page' do
    before { visit signup_path }
    it { is_expected.to have_content('Sign up') }
    it { is_expected.to have_title(full_title('Sign up')) }
  end
  
  describe 'signup' do
    before { visit signup_path }
    let(:submit) { 'Create my account' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Username',     with: 'burgerking'
        fill_in 'Last name',    with: 'King'
        fill_in 'First name',   with: 'Burger'
        fill_in 'Email',        with: 'user@example.com'
        fill_in 'Password',     with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it 'should redirect user to authors index page' do
          expect(current_path).to eq(authors_path)
        end
        it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
  
  describe 'edit' do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { is_expected.to have_content('Update your profile') }
      it { is_expected.to have_title('Edit user') }
      #it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button 'Save changes' }
      it { is_expected.to have_content('error') }
    end
    
    describe 'with valid information' do
      let(:new_last_name)  { 'Last' }
      let(:new_first_name)  { 'First' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Last name',        with: new_last_name
        fill_in 'First name',       with: new_first_name
        fill_in 'Email',            with: new_email
        fill_in 'Password',         with: user.password
        fill_in 'Confirm Password', with: user.password
        click_button 'Save changes'
      end

      it { is_expected.to have_title(new_first_name + ' ' + new_last_name) }
      it { is_expected.to have_selector('div.alert.alert-success') }
      it { is_expected.to have_link('Sign out', href: signout_path) }
      it { expect(user.reload.last_name).to eq(new_last_name) }
      it { expect(user.reload.first_name).to eq(new_first_name) }
      it { expect(user.reload.email).to eq(new_email) }
    end
  end
end

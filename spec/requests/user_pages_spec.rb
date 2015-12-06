require 'rails_helper'

RSpec.describe 'User pages' do
  subject { page }

  context 'regular user' do
    let(:user) { create(:user) }

    describe 'index page' do
      before do
        sign_in user
        visit users_path
      end
      it 'must get redirected to root_path' do
        expect(current_path).to eq(root_path)
      end
    end
  end

  context 'admin user' do
    let(:user) { create(:admin_user) }
    let!(:another_admin_user) { create(:admin_user) }
    let!(:a_regular_user) { create(:user) }

    describe 'index page' do
      before do
        sign_in user
        visit users_path
      end

      it { is_expected.to have_title('All Users') }
      it { is_expected.to have_content('All Users') }

      describe 'pagination' do
        before(:all) { 30.times { create(:user) } }
        after(:all) { User.delete_all }

        it { is_expected.to have_selector('div.pagination') }

        it 'should list each user' do
          User.paginate(page: 1).each do |user|
            expect(page).to have_selector('td', text: user.first_name + ' ' + user.last_name)
          end
        end
      end

      describe 'delete links' do
        it 'should not have a delete link for any admin user' do
          is_expected.not_to have_selector(:xpath, "//a[@href='/account/#{user.username}' and @class='delete-icon']")
          is_expected.not_to have_selector(:xpath, "//a[@href='/account/#{another_admin_user.username}' and @class='delete-icon']")
        end
        it 'should have a delete link for regular user' do
          is_expected.to have_link('', href: user_path(a_regular_user))
        end
        it 'should be able to delete a regular user' do
          expect {
            find(:xpath, "//a[@href='/account/#{a_regular_user.username}' and @class='delete-icon']").click
          }.to change(User, :count).by(-1)
        end
      end

      describe 'delete requests to delete admin user' do
        it 'does not delete admin user' do
          expect {
            delete user_path(another_admin_user)
          }.not_to change(User, :count)
        end
        it 'must get redirected with warning message' do
          delete user_path(another_admin_user)
          expect(current_path).to eq(users_path)
        end
      end
    end

    describe 'show page' do
      before do
        sign_in user
        visit user_path(user)
      end
      it { is_expected.to have_content('Account Settings') }
      it { is_expected.to have_title(full_title('Account Settings')) }
      it { is_expected.to have_link('edit', href: edit_user_path(user)) }
    end

    describe 'new page' do
      before { visit signup_path }
      it { is_expected.to have_content('Sign Up') }
      it { is_expected.to have_title(full_title('Sign Up')) }

      describe 'signup process' do
        let(:submit) { 'Create my account' }

        describe 'with invalid information' do
          it 'should not create a user' do
            expect { click_button submit }.not_to change(User, :count)
          end
        end

        describe 'with valid information' do
          before do
            first_name = Faker::Name.first_name
            fill_in 'user[username]', with: Faker::Internet.user_name(first_name)
            fill_in 'user[last_name]', with: Faker::Name.last_name
            fill_in 'user[first_name]', with: first_name
            fill_in 'user[email]', with: Faker::Internet.email(first_name), match: :first
            fill_in 'user[password]', with: 'foobar'
            fill_in 'user[password_confirmation]', with: 'foobar'
          end

          it 'should create a user' do
            expect { click_button submit }.to change(User, :count).by(1)
          end

          describe 'after saving the user' do
            before { click_button submit }
            let(:user) { User.last }

            it 'user account needs to be activated' do
              expect(user.email_confirmed).to eq(false)
              expect(user.confirm_token).to be_present
              is_expected.to have_selector('div.alert.alert-success', text: 'Please confirm your email address to continue')
            end

            context 'after clicking on activation link in email with valid confirmation token' do
              before { visit confirm_email_user_path(user.confirm_token) }
              it 'should redirect user to authors index page' do
                expect(current_path).to eq(authors_path)
              end
              it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
            end
            context 'guessing activation path with invalid confirmation token' do
              before { visit confirm_email_user_path('abc123') }
              it 'should redirect user to root page' do
                expect(current_path).to eq(root_path)
              end
              it { is_expected.to have_selector('div.alert.alert-danger', text: 'Sorry') }
            end
          end
        end
      end
    end

    describe 'edit page' do
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe 'page' do
        it { is_expected.to have_content('Update Account Settings') }
        it { is_expected.to have_title('Update Account Settings') }
      end

      describe 'with invalid information' do
        before { click_button 'Save changes' }
        it { is_expected.to have_content('error') }
      end

      describe 'with valid information' do
        let(:new_last_name) { Faker::Name.last_name }
        let(:new_first_name) { Faker::Name.first_name }
        let(:new_email) { Faker::Internet.email }
        before do
          fill_in 'Last name',        with: new_last_name
          fill_in 'First name',       with: new_first_name
          fill_in 'Email',            with: new_email
          fill_in 'Password',         with: user.password
          fill_in 'Confirm Password', with: user.password
          click_button 'Save changes'
        end

        it { is_expected.to have_title('Account Settings') }
        it { is_expected.to have_selector('div.alert.alert-success', text: 'Account settings updated!') }
        it { is_expected.to have_link('SIGN OUT', href: signout_path) }
        it { expect(user.reload.last_name).to eq(new_last_name) }
        it { expect(user.reload.first_name).to eq(new_first_name) }
        it { expect(user.reload.email).to eq(new_email) }
      end
    end
  end
end

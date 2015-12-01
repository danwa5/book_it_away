require 'rails_helper'

describe 'Static pages' do
  let(:user) { create(:user) }
  before { sign_in user }

  subject { page }

  describe 'Home page' do
    before { visit root_path }
    it { is_expected.to have_content('Welcome') }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.not_to have_title('| Home') }
  end

  describe 'Help page' do
    before { visit help_path }
    it { is_expected.to have_content('Help') }
    it { is_expected.to have_title(full_title('Help')) }
  end
  
  describe 'About page' do
    before { visit about_path }
    it { is_expected.to have_content('About Us') }
    it { is_expected.to have_title(full_title('About Us')) }
  end
  
  describe 'Contact page' do
    before { visit contact_path }
    it { is_expected.to have_content('Contact') }
    it { is_expected.to have_title(full_title('Contact')) }
  end
  
end

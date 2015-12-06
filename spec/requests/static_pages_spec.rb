require 'rails_helper'

RSpec.describe 'Static pages' do
  let(:user) { create(:user) }
  before { sign_in user }

  subject { page }

  describe 'Home page' do
    before { visit root_path }
    it { is_expected.to have_content(user.first_name.upcase) }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.not_to have_title('| Home') }
  end

  describe 'Search page' do
    before { visit search_path }
    it { is_expected.to have_content('Search') }
    it { is_expected.to have_title(full_title('Search')) }
  end

  describe 'Top 10 page' do
    before { visit top10_path }
    it { is_expected.to have_content('The Top 10') }
    it { is_expected.to have_title(full_title('The Top 10')) }
  end
end

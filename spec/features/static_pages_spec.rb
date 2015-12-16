require 'rails_helper'

RSpec.describe 'Static pages' do
  let(:user) { create(:user) }
  before { sign_in user }

  subject { page }

  describe 'Blog page' do
    before { visit blog_path }
    it { is_expected.to have_content(user.first_name.upcase) }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.to have_selector('li.active', text: 'BLOG') }
  end

  describe 'Search page' do
    before { visit search_path }
    it { is_expected.to have_content('Search') }
    it { is_expected.to have_title(full_title('Search')) }
    it { is_expected.to have_selector('li.active', text: 'SEARCH') }
  end

  describe 'Top 10 page' do
    before { visit top10_path }
    it { is_expected.to have_content('The Top 10') }
    it { is_expected.to have_title(full_title('The Top 10')) }
    it { is_expected.to have_selector('li.active', text: 'TOP 10') }
  end
end

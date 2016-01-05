require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:post)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'scopes' do
    let!(:post_1) { create(:post, status: 1, posted_at: '2015-12-01 01:00:00') }
    let!(:post_2) { create(:post, status: 0, posted_at: '2015-12-01 02:00:00') }
    let!(:post_3) { create(:post, status: 1, posted_at: '2015-12-02 12:00:00') }

    describe '.published' do
      it 'returns posts where status = 1 and in descending order of posted_at' do
        expect(described_class.published).to eq([post_3, post_1])
      end
    end
  end
end

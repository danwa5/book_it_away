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

    describe '.posted_within' do
      context 'month is nil' do
        it 'returns all posts' do
          expect(described_class.posted_within(nil)).to eq([post_1, post_2, post_3])
        end
      end
      context 'month does not have posts' do
        it 'returns no posts' do
          expect(described_class.posted_within('201506')).to eq([])
        end
      end
      context 'month has posts' do
        it 'returns its posts' do
          expect(described_class.posted_within('201512')).to eq([post_1, post_2, post_3])
        end
      end
    end

    describe '.month_and_published_count' do
      it 'returns a list of all months with post count' do
        expect(described_class.month_and_published_count).to eq({ '201512' => 2 })
      end
    end
  end
end

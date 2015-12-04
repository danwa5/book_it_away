require 'rails_helper'

RSpec.describe Review, :type => :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:review)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :book }
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    describe '#book' do
      it { is_expected.to validate_presence_of(:book) }
    end
    describe '#user' do
      it { is_expected.to validate_presence_of(:user) }
    end
    describe '#rating' do
      it { is_expected.to validate_presence_of(:rating) }
      it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:rating).is_less_than_or_equal_to(5) }
    end
    describe '#comments' do
      it { is_expected.to validate_presence_of(:comments) }
    end
  end

  describe 'default scope' do
    let!(:review_1) { create(:review) }
    let!(:review_2) { create(:review) }

    it 'returns all reviews in created_at descending order' do
      expect(described_class.all).to eq([review_2, review_1])
    end
  end
end

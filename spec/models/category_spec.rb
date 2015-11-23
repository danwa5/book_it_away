require 'spec_helper'

describe Category do
  let(:category) { create(:category) }
  subject { category }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:category)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many :books }
  end

  describe 'default scope' do
    let!(:category_1) { create(:category, name: 'Biography')}
    let!(:category_2) { create(:category, name: 'Cooking')}
    let!(:category_3) { create(:category, name: 'Autobiography')}
    it 'returns categories in ascending order of name' do
      expect(described_class.all).to eq([category_3, category_1, category_2])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      it 'strips beginning and ending whitespace' do
        category.name = ' Adventure '
        expect(subject.name).to eq(' Adventure ')
        category.valid?
        expect(subject.name).to eq('Adventure')
      end
    end
    describe 'before_save' do
      it 'titleize the name' do
        category.name = 'fiction'
        category.save
        expect(subject.name).to eq('Fiction')
      end
    end
  end
end

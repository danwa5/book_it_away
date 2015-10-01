require 'spec_helper'

describe Subject do
  let(:subject) { create(:subject) }
  # subject { subject }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:subject)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many :books }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      it 'strips beginning and ending whitespace' do
        subject.name = ' Adventure '
        expect(subject.name).to eq(' Adventure ')
        subject.valid?
        expect(subject.name).to eq('Adventure')
      end
    end
    describe 'before_save' do
      it 'titleize the name' do
        subject.name = 'fiction'
        subject.save
        expect(subject.name).to eq('Fiction')
      end
    end
  end
end

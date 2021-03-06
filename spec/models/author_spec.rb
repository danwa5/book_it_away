require 'rails_helper'

RSpec.describe Author, :type => :model do
  let(:author) { create(:author) }
  subject { author }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:book)).to be_valid
  end
  
  describe 'associations' do
    it { is_expected.to have_many :books }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:books) }
  end

  describe 'callbacks' do
    describe 'after_initialize' do
      subject { Author.new(authors_array: ['Jack Daniels', 'Jim Bean']) }
      it 'takes the first element in array and sets first and last names' do
        expect(subject.first_name).to eq('Jack')
        expect(subject.last_name).to eq('Daniels')
      end
    end
    describe 'before_save' do
      it 'strips leading and trailing whitespace and titleizes the author\'s first and last names' do
        subject.first_name = ' larry'
        subject.last_name = " o'donnell-robinson "
        subject.save
        expect(subject.first_name).to eq('Larry')
        expect(subject.last_name).to eq("O'Donnell-Robinson")
      end
    end
  end

  describe 'validations' do
    describe '#last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_length_of(:last_name).is_at_most(50) }
    end
    describe '#first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_length_of(:first_name).is_at_most(50) }
      it { is_expected.to validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    end
  end

  # Defined in config/initializers/string.rb
  describe '#titleize_lastname' do
    it 'capitalizes the first letter of last name (if appropriate)' do
      expect('decker'.titleize_lastname).to eq('Decker')
      expect('de leon'.titleize_lastname).to eq('de Leon')
      expect('del monte'.titleize_lastname).to eq('del Monte')
    end
  end

  describe '#valid_author_dob' do
    context 'dob is in the future' do
      before { subject.dob = DateTime.now.tomorrow.to_date }
      it { should_not be_valid }
    end
    context 'dob is today' do
      before { subject.dob = Date.today }
      it { should_not be_valid }
    end
    context 'dob is in the past' do
      before { subject.dob = Date.today.prev_day }
      it { should be_valid }
    end
  end

  describe '#name' do
    it 'returns the author\'s first and last names' do
      expect(subject.name).to eq(subject.first_name + ' ' + subject.last_name)
    end
  end

  describe '#nationality_name' do
    context 'nationality is given' do
      it 'returns the full country name' do
        expect(subject.nationality_name).to eq('United States')
      end
    end
    context 'nationality is blank' do
      subject { build(:author, nationality: nil) }
      it 'returns empty string' do
        expect(subject.nationality_name).to eq('')
      end
    end
  end

  describe '#formatted_dob' do
    context 'dob is present' do
      it 'returns a formatted date' do
        expect(subject.formatted_dob).to eq(subject.dob.to_formatted_s(:long))
      end
    end
    context 'dob is nil' do
      it 'returns an empty string' do
        subject.dob = nil
        expect(subject.formatted_dob).to eq('')
      end
    end
  end
end

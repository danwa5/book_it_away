require 'spec_helper'

describe Book do
  let(:book) { create(:book) }
  subject { book }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:book)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :author }
    it { is_expected.to have_many :reviews }
    it { is_expected.to have_and_belong_to_many :subjects }
  end

  describe 'attributes' do
    it { should respond_to(:gbook) }
  end

  describe 'validations' do
    describe '#isbn' do
      it { is_expected.to validate_presence_of(:isbn) }
      it { is_expected.to validate_uniqueness_of(:isbn) }
      it { is_expected.to ensure_length_of(:isbn).is_equal_to(10) }
      it { is_expected.not_to allow_value('123456789a').for(:isbn) }
    end
    describe '#title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to ensure_length_of(:title).is_at_most(100) }
    end
    describe '#publisher' do
      it { is_expected.to ensure_length_of(:publisher).is_at_most(50) }
    end
    describe '#pages' do
      it { is_expected.to validate_numericality_of(:pages).is_greater_than_or_equal_to(1) }
    end
    describe '#author' do
      it { is_expected.to validate_presence_of(:author) }
    end
  end

  describe 'before_save' do
    it 'titleizes the book\'s publisher' do
      subject.publisher = 'world publishing'
      subject.save
      expect(subject.publisher).to eq('World Publishing')
    end
  end

  describe 'default scope' do
    let!(:book_1) { create(:book, title: 'B')}
    let!(:book_2) { create(:book, title: 'C')}
    let!(:book_3) { create(:book, title: 'A')}
    it 'returns books in ascending order of title' do
      expect(described_class.all).to eq([book_3, book_1, book_2])
    end
  end

  describe 'class methods' do
    let(:author) { create(:author, last_name: 'Krakauer', first_name: 'Jon')}
    let!(:book_1) { create(:book, title: 'Into Thin Air', author: author)}
    let!(:book_2) { create(:book, title: 'The Great Gatsby')}
    let!(:book_3) { create(:book, title: 'Into the Wild', author: author)}

    describe '.title_search' do
      it 'returns an array of books based on title search' do
        expect(described_class.title_search('wild').count).to eq(1)
        expect(described_class.title_search('wild')).to eq([book_3])
      end
    end

    describe '.author_search' do
      it 'returns an array of books based on author name search' do
        expect(described_class.author_search('krakauer').count).to eq(2)
        expect(described_class.author_search('krakauer')).to eq([book_1, book_3])
      end
    end

    describe '.google_books_api_isbn_search' do
      pending
    end
  end

  describe 'instance methods from GoogleBooks API' do
    let(:isbn) { '0330470027' }
    let(:gbook) { GoogleBooks.search('isbn: '+isbn).first }
    let!(:book) { create(:book, isbn: isbn, title: 'Into Thin Air', gbook: gbook) }

    describe '#image' do
      context 'book is available in GoogleBooks' do
        it 'returns the book\'s cover image' do
          expect(book.image).to match('http://books.google.com/books/')
        end
      end
      context 'book is not available in GoogleBooks' do
        it 'returns a generic image unavailable link' do
          book.gbook = nil
          expect(book.image).to eq('image_unavailable.jpg')
        end
      end
    end

    describe '#description' do
      context 'book is available in GoogleBooks' do
        it 'returns the book\'s description' do
          expect(book.description).to be_present
        end
      end
      context 'book is not available in GoogleBooks' do
        it 'returns an empty string' do
          book.gbook = nil
          expect(book.description).to eq('')
        end
      end
    end

    describe '#average_rating' do
      context 'book is available in GoogleBooks' do
        it 'returns an average rating >= 0' do
          expect(book.average_rating).to be >= 0
        end
      end
      context 'book is not available in GoogleBooks' do
        it "returns 'n/a'" do
          book.gbook = nil
          expect(book.average_rating).to eq('n/a')
        end
      end
    end

    describe '#ratings_count' do
      context 'book is available in GoogleBooks' do
        it 'returns a rating count > 0' do
          expect(book.ratings_count).to be > 0
        end
      end
      context 'book is not available in GoogleBooks' do
        it 'returns a ratings count of 0' do
          book.gbook = nil
          expect(book.ratings_count).to eq(0)
        end
      end
    end

    describe '#get_google_book_info' do
      it 'returns book details from GoogleBooks' do
        expect(book.get_google_book_info).to be_present
      end
    end
  end

  describe 'subject-related methods' do
    let!(:travel_book) { create(:travel_book) }
    let!(:fiction_book) { create(:fiction_book) }
    let!(:history_fiction_book) { create(:history_fiction_book) }
    let!(:subject) { Subject.find_by(name: 'Fiction') }

    describe '#categorized_under?' do
      it 'returns true if given subject is associated with book' do
        expect(travel_book.categorized_under?(subject)).to eq(false)
        expect(fiction_book.categorized_under?(subject)).to eq(true)
        expect(history_fiction_book.categorized_under?(subject)).to eq(true)
      end
    end

    describe '#non_categorized_subjects' do
      it 'returns all subjects that do not belong to the book' do
        expect(history_fiction_book.non_categorized_subjects).to eq([travel_book.subjects.first])
      end
    end

    describe '#subject_string' do
      context 'book with 0 subject' do
        it 'returns an empty string' do
          expect(book.subject_string).to eq('')
        end
      end
      context 'book with 1 subject' do
        it 'returns a string of its only subject' do
          expect(travel_book.subject_string).to eq('Travel')
        end
      end
      context 'book with multiple subjects' do
        it 'returns a comma-delimited string of its subjects' do
          expect(history_fiction_book.subject_string).to eq('Fiction, History')
        end
      end
    end
  end
end

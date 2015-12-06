require 'rails_helper'

RSpec.describe Book, :type => :model do
  let(:book) { create(:book) }
  subject { book }

  def google_books_stub_request(isbn)
    stub_request(:get, /www.googleapis.com\/books\/v1\/volumes.+#{isbn}.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  it 'has a valid factory' do
    expect(FactoryGirl.build(:book)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to :author }
    it { is_expected.to have_many :reviews }
    it { is_expected.to have_and_belong_to_many :categories }
  end

  describe 'attr_accessor' do
    it { is_expected.to respond_to(:gbook) }
  end

  describe 'validations' do
    describe '#isbn' do
      it { is_expected.to validate_presence_of(:isbn) }
      it { is_expected.to validate_uniqueness_of(:isbn).case_insensitive }
      it { is_expected.to validate_length_of(:isbn).is_equal_to(10) }
      it { is_expected.not_to allow_value('123456789a').for(:isbn) }
    end
    describe '#title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(200) }
    end
    describe '#publisher' do
      it { is_expected.to validate_length_of(:publisher).is_at_most(50) }
    end
    describe '#pages' do
      it { is_expected.to validate_numericality_of(:pages).is_greater_than_or_equal_to(1) }
    end
    describe '#author' do
      it { is_expected.to validate_presence_of(:author) }
    end
  end

  describe 'before_save' do
    it 'strips and titleizes the book\'s title' do
      subject.title = ' the old man and the sea '
      subject.save
      expect(subject.title).to eq('The Old Man and the Sea')
    end
    it 'strips and titleizes the book\'s publisher' do
      subject.publisher = ' world publishing '
      subject.save
      expect(subject.publisher).to eq('World Publishing')
    end
  end

  describe 'scopes' do
    let!(:book_1) { create(:book, title: 'D') }
    let!(:book_2) { create(:book, title: 'B') }
    let!(:book_3) { create(:book, title: 'C') }
    let!(:book_4) { create(:book, title: 'A') }
    let!(:book_5) { create(:book, title: 'E') }

    describe '.sequential' do
      it 'returns books in ascending order of title' do
        expect(described_class.sequential).to eq([book_4, book_2, book_3, book_1, book_5])
      end
    end
    describe '.last_added' do
      it 'returns the last 3 books in descending order of created_at' do
        expect(described_class.last_added).to eq([book_5, book_4, book_3])
      end
    end
    describe '.highest_rated' do
      let!(:review_1) { create(:review, book: book_1, rating: 5.0)}
      let!(:review_3) { create(:review, book: book_3, rating: 0.5)}
      let!(:review_5) { create(:review, book: book_5, rating: 2.0)}
      it 'returns the highest rated books' do
        expect(described_class.highest_rated).to eq([book_1, book_5, book_3])
      end
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
  end

  describe 'instance methods from GoogleBooks API' do
    let(:isbn) { '0330470027' }
    let(:gbook) { google_books_stub_request(isbn) }
    # let(:gbook) { GoogleBooksService.call(isbn) }
    let!(:book) { create(:book, isbn: isbn, title: 'Into Thin Air', gbook: gbook) }

    describe '#load_google_books_data' do
      context 'isbn exists in GoogleBooks' do
        it 'returns book details from GoogleBooks' do
          expect(book.gbook).to be_present
        end
      end
      context 'isbn does not exist in GoogleBooks' do
        pending
      end
    end

    describe '#image' do
      context 'book is available in GoogleBooks' do
        xit 'returns the book\'s cover image' do
          expect(book.image).to be_present
        end
      end
      context 'book is not available in GoogleBooks' do
        it 'returns a generic image unavailable link' do
          book.gbook = nil
          expect(book.image).to eq('books/image_unavailable.jpg')
        end
      end
    end

    describe '#description' do
      context 'book is available in GoogleBooks' do
        xit 'returns the book\'s description' do
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
        xit 'returns an average rating >= 0' do
          expect(book.average_rating).to be >= 0
        end
      end
      context 'book is not available in GoogleBooks' do
        it "returns 'N/A'" do
          book.gbook = nil
          expect(book.average_rating).to eq('N/A')
        end
      end
    end

    describe '#ratings_count' do
      context 'book is available in GoogleBooks' do
        xit 'returns a rating count > 0' do
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
  end

  describe 'category-related methods' do
    let!(:travel_book) { create(:travel_book) }
    let!(:fiction_book) { create(:fiction_book) }
    let!(:history_fiction_book) { create(:history_fiction_book) }
    let!(:category) { Category.find_by(name: 'Fiction') }

    describe '#categorized_under?' do
      it 'returns true if given category is associated with book' do
        expect(travel_book.categorized_under?(category)).to eq(false)
        expect(fiction_book.categorized_under?(category)).to eq(true)
        expect(history_fiction_book.categorized_under?(category)).to eq(true)
      end
    end

    describe '#excluded_categories' do
      it 'returns all categories that do not belong to the book' do
        expect(history_fiction_book.excluded_categories).to eq([travel_book.categories.first])
      end
    end

    describe '#category_string' do
      context 'book with 0 categories' do
        it 'returns an empty string' do
          expect(book.category_string).to eq('')
        end
      end
      context 'book with 1 category' do
        it 'returns a string of its only category' do
          expect(travel_book.category_string).to eq('Travel')
        end
      end
      context 'book with multiple categories' do
        it 'returns a comma-delimited string of its categories' do
          expect(history_fiction_book.category_string).to eq('Fiction, History')
        end
      end
    end

    describe '#add_categories' do
      let(:category2) { Category.find_by(name: 'Travel') }
      let(:category_ids) { [category.id, category2.id] }
      it 'adds categories to book' do
        expect(subject.categories.count).to eq(0)
        subject.add_categories(category_ids)
        expect(subject.categories.count).to eq(2)
        expect(subject.categories.map(&:id)).to eq([category.id, category2.id])
      end
    end

    describe '#remove_categories' do
      it 'removes categories from book' do
        expect(fiction_book.categories.count).to eq(1)
        fiction_book.remove_categories(category)
        expect(fiction_book.categories.count).to eq(0)
      end
    end
  end
end

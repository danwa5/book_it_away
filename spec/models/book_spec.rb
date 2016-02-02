require 'rails_helper'

RSpec.describe Book, :type => :model do
  let(:book) { create(:book) }
  subject { book }

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
      let!(:review_a) { create(:review, book: book_1, rating: 5.0)}
      let!(:review_b) { create(:review, book: book_3, rating: 2.0)}
      let!(:review_c) { create(:review, book: book_5, rating: 1.5)}
      let!(:review_d) { create(:review, book: book_5, rating: 2.5)}
      it 'returns the highest rated books' do
        expect(described_class.highest_rated).to eq([book_1, book_5, book_3])
      end
    end
  end

  describe 'Author#books_count counter cache' do
    let!(:author) { create(:author) }
    it 'must increment books_count by 1 after adding book, or decrement by 1 after deleting book' do
      expect(author.books_count).to eq(0)
      create(:book, author: author)
      author.reload
      expect(author.books_count).to eq(1)
      author.books.first.destroy
      author.reload
      expect(author.books_count).to eq(0)
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
        expect(described_class.author_search('krakauer')).to include(book_1, book_3)
      end
    end
  end

  describe 'instance methods from GoogleBooks API' do
    let(:gbook) { mock_google_books_object }
    let!(:book) { create(:book, :with_cover_image, gbook: gbook) }

    describe '#load_google_books_data' do
      context 'isbn exists in GoogleBooks' do
        it 'returns book details from GoogleBooks' do
          expect(book.gbook).to be_present
        end
      end
      context 'isbn does not exist in GoogleBooks' do
        it 'returns nil' do
          book.gbook = nil
          expect(book.gbook).to be_nil
        end
      end
    end

    describe '#publisher' do
      context 'database value exists' do
        it { expect(book.publisher).to eq(book[:publisher]) }
      end
      context 'database value does not exist but book is available in GoogleBooks' do
        it do
          book[:publisher] = nil
          expect(book.publisher).to eq('Coconut Publishing')
        end
      end
      context 'database value does not exist and book is not available in GoogleBooks' do
        it do
          book[:publisher] = nil
          book.gbook = nil
          expect(book.publisher).to eq('')
        end
      end
    end

    describe '#pages' do
      context 'database value exists' do
        it { expect(book.pages).to eq(book[:pages]) }
      end
      context 'database value does not exist but book is available in GoogleBooks' do
        it do
          book[:pages] = nil
          expect(book.pages).to eq('123')
        end
      end
      context 'database value does not exist and book is not available in GoogleBooks' do
        it do
          book[:pages] = nil
          book.gbook = nil
          expect(book.pages).to eq('')
        end
      end
    end

    describe '#description' do
      context 'database value exists' do
        it { expect(book.description).to eq(book[:description]) }
      end
      context 'database value does not exist but book is available in GoogleBooks' do
        it do
          book[:description] = nil
          expect(book.description).to eq('My first book.')
        end
      end
      context 'database value does not exist and book is not available in GoogleBooks' do
        it do
          book[:description] = nil
          book.gbook = nil
          expect(book.description).to eq('')
        end
      end
    end

    describe '#image' do
      context 'cover image has been imported' do
        it { expect(book.image).to eq(book.cover_small_image.url) }
      end
      context 'cover image has not been imported but book is available in GoogleBooks' do
        it do
          book.cover_small_image = nil
          expect(book.image).to eq('http://example.com/cover_image.jpg')
        end
      end
      context 'cover image has not been imported and book is not available in GoogleBooks' do
        it do
          book.cover_small_image = nil
          book.gbook = nil
          expect(book.image).to eq('books/image_unavailable.jpg')
        end
      end
    end

    describe '#average_rating' do
      context 'book is available in GoogleBooks' do
        it 'returns the book\'s average rating' do
          expect(book.average_rating).to eq('4.5')
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
        it 'returns the book\'s rating count' do
          expect(book.ratings_count).to eq('987')
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

  describe '#api_presenter' do
    it { expect(book.api_presenter).to be_kind_of(Api::BookPresenter) }
  end

  def mock_google_books_object
    attributes = {
      'authors_array' => ['Coconut de Jones'],
      'authors' => 'Coconut de Jones',
      'title' => 'Peas and Carrots',
      'isbn_10' => '1234567890',
      'publisher' => 'Coconut Publishing',
      'published_date' => '2015-12-31',
      'page_count' => '123',
      'description' => 'My first book.',
      'categories' => 'Fiction',
      'image_link' => 'http://example.com/cover_image.jpg',
      'ratings_count' => '987',
      'average_rating' => '4.5'
    }.to_json

    gbook = double('GoogleBooks::Item', JSON.parse(attributes))
  end
end

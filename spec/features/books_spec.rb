require 'rails_helper'

RSpec.describe 'Books', type: :feature do
  let(:author) { create(:author, last_name: 'Miller', first_name: 'Bud') }
  let!(:book) { create(:book, author: author, title: 'Lost On A Mountain') }
  let!(:category_1) { create(:category, name: 'Adventure') }
  let!(:category_2) { create(:category, name: 'Mystery') }
  let(:user) { create(:admin_user) }

  subject { page }

  before { sign_in user }

  describe 'GET /:author_id/:id' do
    before do
      google_books_stub_request
      visit author_book_path(author, book)
    end
    it 'should see the book\'s data' do
      is_expected.to have_title(book.title)
      is_expected.to have_content(book.title)
      is_expected.to have_content('by ' + author.name)
      is_expected.to have_content('ISBN: ' + book.isbn)
      is_expected.to have_content('Publisher: ' + book.publisher)
      is_expected.to have_content('Pages: ' + book.pages.to_s)
    end
    it 'should see a link to edit book' do
      is_expected.to have_link('Edit Book', href: edit_author_book_path(author, book))
    end
    it 'should see a link to write a new review' do
      is_expected.to have_link('Write a review', href: new_author_book_review_path(author, book))
    end
  end

  describe 'GET /:author_id/books/new' do
    before { visit new_author_book_path(author) }
    it 'can add a new book with category' do
      google_books_stub_request
      fill_in 'ISBN', with: '1234567890'
      fill_in 'Title', with: 'The Mountain Has No Summit'
      find("input[type='checkbox'][value='#{category_1.id}']").set(true)
      click_button 'Add Book'
      expect(current_path).to eq(author_path(author))
      is_expected.to have_selector('div.alert.alert-success', text: 'Book successfully added!')
      expect(Book.last.categories).to eq([category_1])
    end
    it 'must display error message after invalid submission' do
      click_button 'Add Book'
      is_expected.to have_selector('div.alert.alert-danger')
    end
    it 'has a cancel button to redirect to author show page' do
      google_books_stub_request
      click_on 'Cancel'
      expect(current_path).to eq(author_path(author))
    end
  end

  describe 'GET /:author_id/:id/edit' do
    before { visit edit_author_book_path(author, book) }
    it { is_expected.to have_title('Update Book') }
    it 'must update book data' do
      google_books_stub_request
      fill_in 'Description', with: 'Read it to find out!'
      click_on 'Save Changes'
      expect(current_path).to eq(author_book_path(author, book))
      is_expected.to have_selector('div.alert.alert-success', text: 'Book updated!')
    end
    it 'must update book categories' do
      google_books_stub_request
      find("input[type='checkbox'][value='#{category_1.id}']").set(false)
      find("input[type='checkbox'][value='#{category_2.id}']").set(true)
      click_on 'Save Changes'
      expect(book.categories).to eq([category_2])
    end
    it 'must display error message if submission is invalid' do
      fill_in 'ISBN', with: ''
      click_on 'Save Changes'
      is_expected.to have_selector('div.alert.alert-danger')
    end
    it 'has a cancel button to redirect to book show page' do
      google_books_stub_request
      click_on 'Cancel'
      expect(current_path).to eq(author_book_path(author, book))
    end
  end

  describe 'DELETE /:author_id/:id' do
    before do
      google_books_stub_request
      visit author_path(author)
    end
    it 'can delete book' do
      click_link 'Delete'
      expect(current_path).to eq(author_path(author))
      is_expected.to have_selector('div.alert.alert-success', text: 'Book deleted')
    end
  end
  
  def google_books_stub_request
    stub_request(:get, /www.googleapis.com\/books\/v1\/volumes.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end

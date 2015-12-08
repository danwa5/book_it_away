require 'rails_helper'

RSpec.describe 'SearchForm', type: :feature do
  let(:user) { create(:user) }
  let(:author) { create(:author, last_name: 'Robinson', first_name: 'Lefty') }
  let!(:book_1) { create(:fiction_book, author: author, title: 'Book #1', isbn: '1111111111', pages: 100) }
  let!(:book_2) { create(:travel_book, author: author, title: 'Book #2', isbn: '2222222222', pages: 200) }

  subject { page }

  before { sign_in user }

  describe 'GET /results' do
    before { google_books_stub_request }
    context 'when searching by author name' do
      before { visit results_path(author: 'lefty') }
      it 'should see both books in the results page' do
        expect(current_path).to eq(results_path)
        is_expected.to have_selector('div.alert.alert-success', text: '2 books found')
        is_expected.to have_content(author.name)
        is_expected.to have_content(book_1.title)
        is_expected.to have_content(book_2.title)
      end
    end
    context 'when searching by title' do
      before { visit results_path(title: '#2') }
      it 'should only see Book #2 in the results page' do
        expect(current_path).to eq(results_path)
        is_expected.to have_selector('div.alert.alert-success', text: '1 book found')
        is_expected.to have_content(author.name)
        is_expected.to have_content(book_2.title)
      end
    end
    context 'when searching by ISBN' do
      before { visit results_path(isbn: '1111111111') }
      it 'should only see Book #1 in the results page' do
        expect(current_path).to eq(results_path)
        is_expected.to have_selector('div.alert.alert-success', text: '1 book found')
        is_expected.to have_content(author.name)
        is_expected.to have_content(book_1.title)
      end
    end
    context 'when searching by page count' do
      before { visit results_path(page_operator: '>', pages: 200) }
      it 'should not see any book in the results page' do
        expect(current_path).to eq(search_path)
        is_expected.to have_selector('div.alert.alert-warning', text: 'No books found')
      end
    end
    context 'when searching by category' do
      before { visit results_path(categories: ['Travel']) }
      it 'should only see Book #2 in the results page' do
        expect(current_path).to eq(results_path)
        is_expected.to have_selector('div.alert.alert-success', text: '1 book found')
        is_expected.to have_content(author.name)
        is_expected.to have_content(book_2.title)
      end 
    end
  end

  def google_books_stub_request
    stub_request(:get, /www.googleapis.com\/books/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
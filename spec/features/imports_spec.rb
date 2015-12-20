require 'rails_helper'

RSpec.describe 'Imports', type: :feature do
  let(:user) { create(:admin_user) }
  let(:image_url) { 'http://example.com/cover_image.jpg' }
  let(:image_file) { Rails.root.join('spec/fixtures/images/cover.jpg') }

  subject { page }

  before { sign_in user }

  describe 'GET /imports' do
    before { visit imports_path }
    it 'has the correct page header' do
      expect(find('div.page-header h2').text).to eq('Google Books Import')
    end
    context 'invalid search' do
      it 'must display error message after invalid submission' do
        make_google_books_stub_request
        click_button 'Search'
        expect(current_path).to eq(imports_path)
        is_expected.to have_selector('div.alert.alert-danger', text: 'ISBN is blank!')
      end
    end
    context 'no search result found' do
      it 'must display error message after invalid submission' do
        make_google_books_stub_request
        fill_in 'ISBN', with: 'abc'
        click_button 'Search'
        expect(current_path).to eq(imports_path)
        is_expected.to have_selector('div.alert.alert-danger', text: 'ISBN cannot be found in Google Books API!')
      end
    end
    context 'search result found' do
      before do
        expect(GoogleBooksService).to receive(:call).with('1234567890').at_least(:once).and_return(mock_google_books_object)
        fill_in 'ISBN', with: '1234567890'
        click_button 'Search'
      end
      it 'must populate hidden import fields with correct values' do
        expect(current_path).to eq(results_imports_path)
        expect(find('#last_name').value).to eq('de Jones')
        expect(find('#first_name').value).to eq('Coconut')
        expect(find('#title').value).to eq('Peas and Carrots')
        expect(find('#isbn').value).to eq('1234567890')
        expect(find('#publisher').value).to eq('Coconut Publishing')
        expect(find('#published_date').value).to eq('2015-12-31')
        expect(find('#pages').value).to eq('123')
        expect(find('#description').value).to eq('My first book.')
        expect(find('#category_name').value).to eq('Fiction')
        expect(find('#cover_image').value).to eq(image_url)
        expect(find('#import_cover_image').value).to eq('true')
      end
      it 'must create new author and book records' do
        make_image_stub_request(image_url)
        click_button 'Import Author and Book'
        author = Author.last
        expect(current_path).to eq(author_path(author))
        is_expected.to have_selector('div.alert.alert-success', text: 'Author and book data successfully imported!')
      end
      it 'must display error message after unsuccessful import' do
        find('#last_name').set('')
        click_button 'Import Author and Book'
        expect(current_path).to eq(imports_path)
        is_expected.to have_selector('div.alert.alert-danger', text: 'Author and book data could not be imported')
      end
    end
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
      'image_link' => image_url,
      'ratings_count' => '987',
      'average_rating' => '4.5'
    }.to_json

    gbook = double('GoogleBooks::Item', JSON.parse(attributes))
  end

  def make_google_books_stub_request
    stub_request(:get, /www.googleapis.com\/books\/v1\/volumes.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  def make_image_stub_request(url)
    stub_request(:get, url).to_return(status: 200, body: image_file.read)
  end
end
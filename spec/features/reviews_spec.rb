require 'rails_helper'

RSpec.describe 'Reviews', type: :feature do
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let!(:review) { create(:review, book: book, user: user) }

  subject { page }

  before { sign_in user }
  
  describe 'GET /:author_id/:book_id/reviews/new' do
    before { visit new_author_book_review_path(book.author, book) }
    it { is_expected.to have_title('New Review') }
    xit 'can add a new book review' do
      # find(:xpath, "//img[@src='/assets/star-off.png' and @title='awesome']").click
      # find(:css,'div#user_star').click
      # find("#user_star").click
      fill_in 'Comments', with: 'I love this book!'
      click_button 'Add Review'
      expect(current_path).to eq(author_book_path(book.author, book))
    end
    it 'must display error message after invalid submission' do
      click_button 'Add Review'
      is_expected.to have_selector('div.alert.alert-danger')
    end
    it 'has a cancel button to redirect to book show page' do
      google_books_stub_request
      click_on 'Cancel'
      expect(current_path).to eq(author_book_path(book.author, book))
    end
  end

  describe 'GET /:author_id/:book_id/reviews/:id/edit' do
    before { visit edit_author_book_review_path(book.author, book, review) }
    it { is_expected.to have_title('Update Review') }
    xit 'must update the review' do
      # find(:xpath, "//input[@name='score']").set('5')
      find("input[name='score']").set('5')
      fill_in 'Comments', with: 'I love this book so much!'
      click_on 'Save Changes'
      is_expected.to have_selector('div.alert.alert-success', text: 'Review updated!')
    end
    it 'must display error message if submission is invalid' do
      fill_in 'Comments', with: ''
      click_on 'Save Changes'
      is_expected.to have_selector('div.alert.alert-danger')
    end
    it 'has a cancel button to redirect to book show page' do
      google_books_stub_request
      click_on 'Cancel'
      expect(current_path).to eq(author_book_path(book.author, book))
    end
  end

  describe 'PUT /:author_id/:book_id/reviews/:review_id/like & /:author_id/:book_id/reviews/:review_id/dislike' do
    before do
      google_books_stub_request
      visit author_book_path(book.author, book)
    end
    it 'should be able to like a review' do
      expect(review.likes).to eq(0)
      find(:css,'input.btn-success').click
      review.reload
      expect(review.likes).to eq(1)
    end
    it 'should be able to dislike a review' do
      expect(review.dislikes).to eq(0)
      find(:css,'input.btn-danger').click
      review.reload
      expect(review.dislikes).to eq(1)
    end
  end

  def google_books_stub_request
    stub_request(:get, /www.googleapis.com\/books\/v1\/volumes.+/).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
require 'rails_helper'

RSpec.describe Api::BooksController, type: :controller do
  let(:book) { create(:book) }

  describe 'GET /api/books/:id' do
    context 'for valid book' do
      it 'successfully responds to a basic get request' do
        get :show, id: book.id
        expect(response).to be_success
      end

      it 'responds with the correct JSON' do
        get :show, id: book.id
        expect(JSON.parse(response.body)).to eq(JSON.parse(JSON.generate(book.api_presenter.as_json)))
      end
    end
    context 'for invalid book' do
      it 'returns an empty hash' do
        get :show, id: (book.id + 1)
        expect(JSON.parse(response.body)).to eq({})
      end
    end
  end
end

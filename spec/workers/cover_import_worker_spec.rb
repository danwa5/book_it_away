require 'rails_helper'

RSpec.describe CoverImportWorker do
  let(:book) { create(:book) }
  let(:image_asset) { Rails.root.join('spec/fixtures/images/cover.jpg') }
  let(:image_asset_url) { remote_asset_url(image_asset) }

  it { is_expected.to be_kind_of(Sidekiq::Worker) }

  describe '#perform' do
    context 'when book_id cannot be found' do
      it 'returns false' do
        result = CoverImportWorker.new.perform(book.id+1)
        expect(result).to eq(false)
      end
    end
    context 'when cover_image_url is given' do
      context 'but it is not accessible' do
        before { stub_request(:get, image_asset_url).to_return(status: 404, body: '') }
        it 'returns false' do
          expect(run_worker(true)).to eq(false)
        end
      end
      context 'and it is accessible' do
        before do
          stub_request(:get, image_asset_url).to_return(status: 200, body: image_asset)
        end
        it 'sets the cover image for book' do
          expect(book.cover_image_uid).to be_nil
          run_worker(true)
          book.reload
          expect(book.cover_image_uid).to be_present
        end
        it 'returns the book id' do
          expect(run_worker(true)).to eq(book.id)
        end
      end
    end
    context 'when cover_image_url is not given' do
      context 'and image from GoogleBooks is missing' do
        it 'returns false' do
          expect(GoogleBooksService).to receive(:call).with(book.isbn).at_least(:once).and_return(mock_google_books_object(false))
          expect(run_worker(false)).to eq(false)
        end
      end
      context 'and image from GoogleBooks is found' do
        before do
          stub_request(:get, image_asset_url).to_return(status: 200, body: image_asset)
        end
        it 'saves the image as cover image' do
          expect(GoogleBooksService).to receive(:call).with(book.isbn).at_least(:once).and_return(mock_google_books_object(true))
          expect(book.cover_image_uid).to be_nil
          run_worker(false)
          book.reload
          expect(book.cover_image_uid).to be_present
        end
        it 'returns the book id' do
          expect(GoogleBooksService).to receive(:call).with(book.isbn).at_least(:once).and_return(mock_google_books_object(true))
          expect(run_worker(false)).to eq(book.id)
        end
      end
    end
  end

  def remote_asset_url(asset)
    File.join('http://localhost:3000', asset.basename)
  end

  def run_worker(with_image=false)
    image_url = with_image ? image_asset_url : nil
    subject.perform(book.id, image_url)
  end

  def mock_google_books_object(with_image=false)
    image_url = with_image ? image_asset_url : nil
    attributes = {
      'image_link' => image_url,
    }.to_json

    gbook = double('GoogleBooks::Item', JSON.parse(attributes))
  end
end

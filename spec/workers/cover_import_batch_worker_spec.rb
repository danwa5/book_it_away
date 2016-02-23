require 'rails_helper'

RSpec.describe CoverImportBatchWorker do
  

  it { is_expected.to be_kind_of(Sidekiq::Worker) }

  describe '#perform' do
    context 'all books have a cover image' do
      let!(:book_1) { create(:book, :with_cover_image) }
      let!(:book_2) { create(:book, :with_cover_image) }

      it 'returns false' do
        expect(subject.perform).to eq(false)
      end
    end
    context 'at least one book is missing a cover image' do
      let!(:book_1) { create(:book) }
      let!(:book_2) { create(:book, :with_cover_image) }
      let!(:book_3) { create(:book) }

      it 'enqueues a CoverImportWorker for each book without a cover image' do
        expect {
          subject.perform
        }.to change(CoverImportWorker.jobs, :size).by(2)
      end
    end
  end
end

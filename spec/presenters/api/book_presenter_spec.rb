require 'rails_helper'

RSpec.describe Api::BookPresenter do
  let(:author) { create(:author, last_name: 'Last', first_name: 'First') }
  let(:book) do
    create(:book, {
      author: author,
      title: 'My First Book',
      isbn: '1234567890',
      publisher: 'Publisher',
      published_date: '2016-01-02',
      pages: 123,
      description: 'Description',
      slug: 'my-first-book',
      cover_image_uid: 'books/cover.jpg',
      cover_small_image_uid: 'books/cover_small.jpg'
    })
  end

  subject { described_class.new(book) }

  it { is_expected.to be_kind_of(::Presenters::Base) }

  describe '#as_json' do
    it 'returns correctly-formatted json' do
      expect(JSON.parse(subject.to_json)).to eq({
        'title' => 'My First Book',
        'isbn' => '1234567890',
        'author' => 'First Last',
        'publisher' => 'Publisher',
        'published_date' => '2016-01-02',
        'pages' => 123,
        'description' => 'Description',
        'slug' => 'my-first-book',
        'cover_image_url' => book.cover_image_url,
        'cover_small_image_url' => book.cover_small_image_url
      })
    end
  end
end

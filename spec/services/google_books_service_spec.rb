require 'rails_helper'

RSpec.describe GoogleBooksService, type: :model do
  let(:isbn) { '1234567890' }

  describe '.call' do
    it 'makes a request to GoogleBooks API with isbn' do
      expect_any_instance_of(described_class).to receive(:call).with(isbn)
      described_class.call(isbn)
    end
  end

  describe '#call' do
    context 'successfull attempt' do
      it 'makes a request to GoogleBooks API with isbn' do
        expect(GoogleBooks).to receive_message_chain(:search, :first)
        described_class.new.call(isbn)
      end
    end
    context 'failed attempt' do
      it 'should log the error message' do
        allow_any_instance_of(described_class).to receive(:call).and_raise(SocketError, 'GoogleBooksService.call failed for ISBN ' + isbn)
        expect{ described_class.new.call(isbn) }.to raise_exception(SocketError)
      end
    end
  end
end
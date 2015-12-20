require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context 'page_title is not present' do
      it { expect(helper.full_title('')).to eq('Book-It-Away') }
    end
    context 'page_title is present' do
      it { expect(helper.full_title('Authors')).to eq('Book-It-Away | Authors') }
    end
  end

  describe '#date_format' do
    context 'date is nil' do
      it { expect(helper.date_format(nil)).to eq('N/A') }
    end
    context 'date is present' do
      it do
        date = Time.now()
        expect(helper.date_format(date)).to eq(date.strftime('%b %d, %Y'))
      end
    end
  end
end

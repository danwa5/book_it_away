require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin_user) }

  before { helper.sign_in(user) }

  describe '#sign_in' do
    it do
      expect(user.remember_token).not_to be_nil
      expect(self.current_user).to eq(user)
    end
  end

  describe '#signed_in?' do
    it { expect(helper.signed_in?).to be_truthy }
  end

  describe '#current_user?' do
    it { expect(helper.current_user?(user)).to be_truthy }
    it { expect(helper.current_user?(admin)).to be_falsey }
  end

  describe '#current_user' do
    it { expect(helper.current_user).to eq(user) }
  end

  # describe '#admin_user' do
  #   it do
  #     helper.admin_user
  #     expect(page.current_path).to eq(root_url)
  #   end
  # end

  describe '#sign_out' do
    it do
      helper.sign_out
      expect(current_user).to be_nil
    end
  end
end

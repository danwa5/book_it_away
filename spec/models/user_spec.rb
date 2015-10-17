require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:reviews) }
  end

  describe 'validations' do
    describe '#last_name' do
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to ensure_length_of(:last_name).is_at_most(50) }
    end
    describe '#first_name' do
      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to ensure_length_of(:first_name).is_at_most(50) }
    end
    describe '#username' do
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to ensure_length_of(:username).is_at_most(20) }
    end
    describe '#email' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { expect(subject.email).to match(described_class::VALID_EMAIL_REGEX) }
    end
    describe '#password' do
      it { is_expected.to ensure_length_of(:password).is_at_least(6) }
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'email becomes lowercase' do
        user.email = 'USER@EMAIL.COM'
        user.save
        expect(user.email).to eq('user@email.com')
      end
    end
  end

  describe 'constants' do
    it { expect(described_class::VALID_EMAIL_REGEX).to eq(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_digest) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:remember_token) }
    it { is_expected.to respond_to(:authenticate) }
    it { is_expected.to respond_to(:admin) }
  end
  
  describe '#admin' do
    context 'user is not an admin' do
      it { is_expected.to_not be_admin }
    end
    context 'user is an admin' do
      let(:admin_user) { create(:admin_user) }
      it { expect(admin_user).to be_admin }
    end
  end

  describe '#name' do
    it 'returns first_name and last_name' do
      expect(subject.name).to eq(subject.first_name + ' ' + subject.last_name)
    end
  end
  
  describe '#email' do
    context 'when email format is invalid' do
      it 'should be invalid' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).not_to be_valid
        end
      end
    end
    context 'when email format is valid' do
      it 'should be valid' do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
    context 'when email address is already taken' do
      let(:user_with_same_email) { user.dup }
      before do
        user_with_same_email.email = user.email.upcase
        user_with_same_email.save
      end
      it { expect(user_with_same_email).to_not be_valid }
    end
  end

  describe '#password' do
    context 'when password is not present' do
      before do
        user.password = ' '
        user.password_confirmation = ' '
      end
      it { is_expected.to_not be_valid }
    end
    context 'when password does not match confirmation' do
      before { user.password_confirmation = 'mismatch' }
      it { is_expected.to_not be_valid }
    end
    context 'when a password is too short' do
      before { user.password = user.password_confirmation = 'a' * 5 }
      it { is_expected.to_not be_valid }
    end
  end

  describe '#remember token' do
    before { subject.save }
    it { expect(subject.remember_token).to_not be_blank }
  end
end

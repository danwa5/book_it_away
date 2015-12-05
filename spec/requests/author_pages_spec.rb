require 'rails_helper'

describe 'AuthorPages' do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:admin_user) }
  let!(:author) { create(:author) }

  before { sign_in user }

  subject { page }
  
  describe 'index page' do
    before { visit authors_path }
    
    it { is_expected.to have_title('All Authors') }
    it { is_expected.to have_text('All Authors') }
    
    it 'should list each author' do
      Author.all.each do |author|
        expect(page).to have_selector('li', text: author.first_name + ' ' + author.last_name)
      end
    end
    
    context 'when a non-admin user is signed in' do
      it { is_expected.not_to have_link('Add new author', href: new_author_path) }
    end
    context 'when an admin user is signed in' do
      before do
        sign_in admin_user
        visit authors_path
      end
      it { is_expected.to have_link('Add new author', href: new_author_path) }
    end
  end
  
  describe 'show page' do
    before { visit author_path(author) }

    it { is_expected.to have_content(author.last_name) }
    it { is_expected.to have_content(author.first_name) }
    it { is_expected.to have_title(author.first_name + ' ' + author.last_name) }
    
    context 'when a non-admin user is signed in' do
      it { is_expected.to have_link('Add Book') }
      it { is_expected.not_to have_link('Edit Author') }
      it { is_expected.not_to have_link('Delete Author') }
      
      context 'when the author has a book entry' do
        let!(:book) { create(:book, author: author) }
        before { visit author_path(author) }
        it { is_expected.to have_link('Edit', href: edit_author_book_path(author, book)) }
      end
      context 'when the author has no book entries' do
        before do
          delete :destroy, { id: author }
        end
        xit 'deleting author is not permitted' do
          # expect {
          #   delete :destroy, id: author
          # }.not_to change(Author, :count)
        end
      end
    end
    context 'when an admin user is signed in' do
      before do
        sign_in admin_user
        visit author_path(author)
      end
      it { is_expected.to have_link('Add Book') }
      it { is_expected.to have_link('Edit Author') }
      it { is_expected.to have_link('Delete Author') }

      context 'when the author has a book entry' do
        let!(:book) { create(:book, author: author) }
        before { visit author_path(author) }
        it { is_expected.to have_link('Edit', href: edit_author_book_path(author, book)) }
      end
    end
  end
  
  describe 'edit page' do
    context 'when a non-admin user is signed in' do
      it 'should get redirected to author show page' do
        visit edit_author_path(author)
        expect(current_path).to eq(author_path(author))
      end
    end
    context 'when an admin user is signed in' do
      before do
        sign_in admin_user
        visit edit_author_path(author)
      end

      it { is_expected.to have_content('Update Author') }
      it { is_expected.to have_title('Edit author') }
      
      context 'with invalid information' do
        before do
          fill_in 'Last name', with: ''
          fill_in 'First name', with: ''
          click_button 'Save Changes'
        end

        it 'should get redirected back to edit page with error message' do
          is_expected.to have_content('The form contains the 2 errors below')
        end
      end
      context 'with valid information' do
        let(:new_last_name)  { Faker::Name.last_name }
        let(:new_first_name)  { Faker::Name.first_name }
        let(:new_nationality)  { 'Canada' }
        before do
          fill_in 'Last name', with: new_last_name
          fill_in 'First name', with: new_first_name
          select new_nationality, from: 'Nationality'
          click_button 'Save Changes'
        end

        it 'should update successfully' do
          is_expected.to have_title(new_first_name + ' ' + new_last_name)
          is_expected.to have_selector('div.alert.alert-success')
          expect(author.reload.last_name).to eq(new_last_name)
          expect(author.reload.first_name).to eq(new_first_name)
        end
      end
    end
  end
  
  describe 'new page' do
    context 'when a non-admin user is signed in' do
      it 'should get redirected to author show page' do
        visit new_author_path
        expect(current_path).to eq(authors_path)
      end
    end
    context 'when an admin user is signed in' do
      before do
        sign_in admin_user
        visit new_author_path
      end

      it { is_expected.to have_content('New Author') }
      it { is_expected.to have_title('New Author') }
      
      context 'with invalid information' do
        it 'should not add author' do
          expect { click_button 'Add Author' }.not_to change(Author, :count)
        end
      end
      context 'with valid information' do
        let(:new_last_name) { Faker::Name.last_name }
        let(:new_first_name) { Faker::Name.first_name }
        let(:new_nationality) { 'Canada' }
        before do
          fill_in 'Last name', with: new_last_name
          fill_in 'First name', with: new_first_name
          select new_nationality, from: 'Nationality'
        end
        
        it 'should create an author' do
          expect { click_button 'Add Author' }.to change(Author, :count).by(1)
        end
        
        describe 'after adding author' do
          before { click_button 'Add Author' }
          it { is_expected.to have_title(new_first_name + ' ' + new_last_name) }
          it { is_expected.to have_selector('div.alert.alert-success') }
        end
      end
    end
  end
end

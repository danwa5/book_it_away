require 'rails_helper'

RSpec.describe 'Categories', type: :feature do
  let!(:category_1) { create(:category, name: 'Biography') }
  let!(:category_2) { create(:category, name: 'Cooking') }

  subject { page }

  context 'regular user' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe 'GET /categories' do
      before { visit categories_path }
      it 'should be redirected to root path' do
        expect(current_path).to eq(root_path)
      end
    end
    describe 'GET /categories/new' do
      before { visit new_category_path }
      it 'should be redirected to root path' do
        expect(current_path).to eq(root_path)
      end
    end
    describe 'GET /categories/:id/edit' do
      before { visit edit_category_path(category_2) }
      it 'should be redirected to root path' do
        expect(current_path).to eq(root_path)
      end
    end
  end

  context 'admin user' do
    let(:user) { create(:admin_user) }
    before { sign_in user }

    describe 'GET /categories' do
      before { visit categories_path }
      it 'should see all the different categories' do
        is_expected.to have_title('All Book Categories')
        is_expected.to have_content(category_1.name)
        is_expected.to have_content(category_2.name)
      end
      it 'should see a link to edit each category' do
        is_expected.to have_link('Edit', href: edit_category_path(category_1))
        is_expected.to have_link('Edit', href: edit_category_path(category_2))
      end
      it 'should see a link to create new category' do
        is_expected.to have_link('Add new category', href: new_category_path)
      end
    end

    describe 'GET /categories/new' do
      before { visit new_category_path }
      it { is_expected.to have_title('New Category') }
      it 'can create a new category' do
        fill_in 'Name', with: 'Travel'
        click_on 'Add Category'
        expect(current_path).to eq(categories_path)
        is_expected.to have_selector('div.alert.alert-success', text: 'Category successfully added!')
      end
      it 'must display error message if category name already exists' do
        fill_in 'Name', with: 'Cooking'
        click_on 'Add Category'
        is_expected.to have_selector('div.alert.alert-danger', text: 'Name has already been taken')
      end
      it 'has a cancel button to redirect to index page' do
        click_on 'Cancel'
        expect(current_path).to eq(categories_path)
      end
    end

    describe 'GET /categories/:id/edit' do
      before { visit edit_category_path(category_2) }
      it { is_expected.to have_title('Update Category') }
      it 'must update category name' do
        fill_in 'Name', with: 'Cooking & Cleaning'
        click_on 'Save Changes'
        expect(current_path).to eq(categories_path)
        is_expected.to have_selector('div.alert.alert-success', text: 'Category updated!')
      end
      it 'must display error message if name changed to one that already exists' do
        fill_in 'Name', with: category_1.name
        click_on 'Save Changes'
        is_expected.to have_selector('div.alert.alert-danger', text: 'Name has already been taken')
      end
      it 'has a cancel button to redirect to index page' do
        click_on 'Cancel'
        expect(current_path).to eq(categories_path)
      end
    end
  end
end
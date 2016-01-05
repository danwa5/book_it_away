require 'rails_helper'

RSpec.describe 'Posts', type: :feature do

  subject { page }

  context 'admin user' do
    let(:user) { create(:admin_user) }
    let!(:post) { create(:post, user: user) }

    before { sign_in user }

    describe 'GET /account/:user_id/posts' do
      let(:user_2) { create(:admin_user) }
      let!(:post_2) { create(:post, user: user_2) }

      it 'should only see own posts' do
        visit user_posts_path(user)
        is_expected.to have_title('My Posts')
        is_expected.to have_content('My Posts')
        is_expected.to have_content(post.title)
        is_expected.not_to have_content(post_2.title)
      end
    end

    describe 'GET /account/:user_id/posts/:id' do
      before { visit user_post_path(user, post) }
      it 'should see the post\'s data' do
        is_expected.to have_title('Blog Post')
        is_expected.to have_content('Blog Post')
      end
      it 'should see a link to edit post' do
        is_expected.to have_link('edit', href: edit_user_post_path(user, post))
      end
    end

    describe 'GET /account/:user_id/posts/new' do
      before { visit new_user_post_path(user) }
      it 'can create a new post' do
        fill_in 'Title', with: 'My Title'
        fill_in 'Body', with: 'My blog post.'
        click_button 'Add Post'
        post = Post.last
        expect(current_path).to eq(user_post_path(user, post))
        is_expected.to have_selector('div.alert.alert-success', text: 'Blog post successfully added!')
      end
      it 'must display error message after invalid submission' do
        visit new_user_post_path(user)
        click_button 'Add Post'
        is_expected.to have_selector('div.alert.alert-danger')
      end
      it 'has a cancel button to redirect to blog' do
        click_on 'Cancel'
        expect(current_path).to eq(blog_path)
      end
    end

    describe 'GET /account/:user_id/posts/:id/edit' do
      before { visit edit_user_post_path(user, post) }
      it { is_expected.to have_title('Update Blog Post') }
      it 'must update post data' do
        fill_in 'Body', with: Faker::Hipster.sentence
        click_on 'Save Changes'
        expect(current_path).to eq(user_post_path(user, post))
        is_expected.to have_selector('div.alert.alert-success', text: 'Blog post updated!')
      end
      it 'must display error message if submission is invalid' do
        fill_in 'Title', with: ''
        click_on 'Save Changes'
        is_expected.to have_selector('div.alert.alert-danger')
      end
      it 'has a cancel button to redirect to post show page' do
        click_on 'Cancel'
        expect(current_path).to eq(user_post_path(user, post))
      end
    end
  end

  context 'non-admin user' do
    let(:user) { create(:user) }
    let(:admin_user) { create(:admin_user) }
    let!(:post) { create(:post, user: admin_user) }

    before { sign_in user }

    describe 'GET /account/:user_id/posts' do
      before { visit user_posts_path(user) }
      it 'must not have access and be redirected' do
        expect(current_path).to eq(root_path)
      end
    end

    describe 'GET /account/:user_id/posts/:id' do
      before { visit user_post_path(admin_user, post) }
      it 'must not have access to another user\'s post and be redirected' do
        expect(current_path).to eq(root_path)
      end
    end

    describe 'GET /account/:user_id/posts/new' do
      before { visit new_user_post_path(user) }
      it 'must not have access and be redirected' do
        expect(current_path).to eq(root_path)
      end
    end

    describe 'GET /account/:user_id/posts/:id/edit' do
      before { visit edit_user_post_path(admin_user, post) }
      it 'must not have access to another user\'s post and be redirected' do
        expect(current_path).to eq(root_path)
      end
    end
  end
end
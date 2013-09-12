require 'spec_helper'

describe "AuthorPages" do
 
  subject { page }
  
  describe "index" do
    let(:author) { FactoryGirl.create(:author) }
    before do
      visit authors_path
    end
    
    it { should have_title('All Authors') }
    it { should have_content('All Authors') }
    
    it "should list each author" do
      Author.all.each do |author|
        expect(page).to have_selector('li', text: author.first_name + " " + author.last_name)
      end
    end
    
    describe "'add new author' link" do
      it { should_not have_link('Add new author') }
      
      describe "only visible to an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit authors_path
        end

        it { should have_link('Add new author', href: new_author_path) }
      end
    end
  end
  
  describe "author page" do
    let(:author) { FactoryGirl.create(:author) }
    before { visit author_path(author) }

    it { should have_content(author.last_name) }
    it { should have_content(author.first_name) }
    it { should have_title(author.first_name + " " + author.last_name) }
    
    describe "links" do
      it { should_not have_link('Add Book') }
      it { should_not have_link('Edit Author') }
      it { should_not have_link('Delete Author') }
      
      describe "visible to non-admin users" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          visit author_path(author)
        end
        it { should have_link('Add Book') }
        it { should have_link('Edit Author') }
        it { should_not have_link('Delete Author') }
      end
      
      describe "visible to non-admin users" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit author_path(author)
        end
        it { should have_link('Add Book') }
        it { should have_link('Edit Author') }
        it { should have_link('Delete Author') }
      end
    end
  end
  
  describe "edit author" do
    let(:user) { FactoryGirl.create(:user) }
    let(:author) { FactoryGirl.create(:author) }
    before do
      sign_in user
      visit edit_author_path(author)
    end

    describe "page" do
      it { should have_content("Update Author") }
      it { should have_title("Edit author") }
    end
    
    describe "with invalid information" do
      let(:new_last_name)  { "" }
      let(:new_first_name)  { "" }
      before do
        fill_in "Last name",        with: new_last_name
        fill_in "First name",       with: new_first_name
        click_button "Save changes"
      end

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_last_name)  { "Block" }
      let(:new_first_name)  { "Writer" }
      #let(:new_dob)  { "1950-01-01" }
      let(:new_nationality)  { "Canada" }
      before do
        fill_in "Last name",        with: new_last_name
        fill_in "First name",       with: new_first_name
        #select new_dob, from: "Date of Birth"
        select new_nationality, from: "Nationality"
        click_button "Save changes"
      end

      it { should have_title(new_first_name + " " + new_last_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { expect(author.reload.last_name).to  eq new_last_name }
      specify { expect(author.reload.first_name).to  eq new_first_name }
    end
  end
  
  describe "new author" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_author_path
    end
    
    describe "page" do
      it { should have_content("New Author") }
      it { should have_title("New Author") }
    end
    
    describe "with invalid information" do
      it "should not add author" do
        expect { click_button "Add Author" }.not_to change(Author, :count)
      end
    end
    
    describe "with valid information" do
      let(:new_last_name)  { "Blog" }
      let(:new_first_name)  { "Joe" }
      let(:new_nationality)  { "Canada" }
      before do
        fill_in "Last name", with: new_last_name
        fill_in "First name", with: new_first_name
        select new_nationality, from: "Nationality"
      end
      
      it "should create an author" do
        expect { click_button "Add Author" }.to change(Author, :count).by(1)
      end
      
      describe "after adding author" do
        before { click_button "Add Author" }
        it { should have_title(new_first_name + " " + new_last_name) }
        it { should have_selector('div.alert.alert-success') }
      end
    end
  end
 
end

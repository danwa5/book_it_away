require 'spec_helper'

describe Book do
  
  let(:author) { FactoryGirl.create(:author) }
  before { @book = author.books.build(isbn: "0123456789", title: "My Book") }

  subject { @book }

  it { should respond_to(:isbn) }
  it { should respond_to(:title) }
  it { should respond_to(:publisher) }
  it { should respond_to(:pages) }
  it { should respond_to(:author_id) }
  its(:author) { should eq author }

  it { should be_valid }

  describe "when author_id is not present" do
    before { @book.author_id = nil }
    it { should_not be_valid }
  end

  describe "when isbn is not present" do
    before { @book.isbn = " " }
    it { should_not be_valid }
  end
  
  describe "when isbn does not consist of only numbers" do
    before { @book.isbn = "12345ab678" }
    it { should_not be_valid }
  end
  
  describe "when isbn is not 10 characters long" do
    before { @book.isbn = "5" * 11 }
    it { should_not be_valid }
  end
  
  describe "when title is not present" do
    before { @book.title = " " }
    it { should_not be_valid }
  end
  
  describe "when title is more than 100 characters long" do
    before { @book.title = "a" * 101 }
    it { should_not be_valid }
  end
  
  describe "when publisher is more than 50 characters long" do
    before { @book.publisher = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when publisher is nil" do
    before { @book.publisher = nil }
    it { should be_valid }
  end
  
  describe "when pages is not >= 1" do
    before { @book.pages = 0 }
    it { should_not be_valid }
  end
  
  describe "when pages is nil" do
    before { @book.pages = nil }
    it { should be_valid }
  end
  
  describe "when pages does not consist of only numbers" do
    before { @book.pages = "12ab" }
    it { should_not be_valid }
  end
  
end

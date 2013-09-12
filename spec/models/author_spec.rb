require 'spec_helper'

describe Author do

  #let(:author) { FactoryGirl.create(:author) }
  
  before do
    @author = Author.new(last_name: "Krakauer", first_name: "Jon", 
                       dob: "1954-04-12", nationality: "USA")
  end
  
  subject { @author }
  
  it { should respond_to(:last_name) }
  it { should respond_to(:first_name) }
  it { should respond_to(:dob) }
  it { should respond_to(:nationality) }
  it { should be_valid }
  
  describe "when last name is not present" do
    before { @author.last_name = " " }
    it { should_not be_valid }
  end
  
  describe "when first name is not present" do
    before { @author.first_name = " " }
    it { should_not be_valid }
  end
  
  #describe "when last name/first name is already taken" do
  #  before do
  #    duplicate_author = @author.dup
  #    duplicate_author.last_name = @author.last_name.downcase
  #    duplicate_author.first_name = @author.first_name.downcase
  #    duplicate_author.save
  #  end

  #  it { should_not be_valid }
  #end
  
  describe "when dob is today" do
    before { @author.dob = Date.today }
    it { should_not be_valid }
  end
  
  describe "when dob is after today's date" do
    before { @author.dob = Date.tomorrow }
    it { should_not be_valid }
  end
  
  describe "when nationality is not in permitted list" do
    before { @author.nationality = 'France' }
    it { should_not be_valid }
  end
  
end

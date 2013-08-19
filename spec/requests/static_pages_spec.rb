require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    it { should have_content('Book App') }
    it { should have_title(full_title("Home")) }
  end

  describe "Help page" do
    before { visit help_path }
    
    it { should have_content('Help') }
    it { should have_title(full_title("Help")) }
    
    #it "should have the content 'Help'" do
    #  visit help_path
    #  expect(page).to have_content('Help')
    #end
    
    #it "should have the title 'Help'" do
    #  visit help_path
    #  expect(page).to have_title("Daniel's Book App | Help")
    #end
  end
end

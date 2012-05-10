require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_heading 'Rails Template' }
    it { should have_full_title }
    it { should_not have_title '| Home' }
  end
  
  describe "Help page" do
    before { visit help_path }

    it { should have_heading    'Help' }
    it { should have_full_title 'Help' }
  end
  
  describe "About page" do
    before { visit about_path }

    it { should have_heading    'About Us' }
    it { should have_full_title 'About Us' }
  end
  
  describe "Contact page" do
    before { visit contact_path }

    it { should have_heading    'Contact' }
    it { should have_full_title 'Contact' }
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_full_title 'About Us'
    click_link "Help"
    page.should have_full_title 'Help'
    click_link "Contact"
    page.should have_full_title 'Contact'
    click_link "Home"
    page.should have_full_title
    page.should_not have_title '| Home'
    click_link "Sign up now!"
    page.should have_full_title 'Sign Up'
  end
end

require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Rails Template'" do
      visit '/static_pages/home'
      page.should have_content('Rails Template')
    end
  end
  
  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end
end

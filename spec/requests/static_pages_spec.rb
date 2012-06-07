require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_heading 'Rails Template' }
    it { should have_full_title }
    it { should_not have_title '| Home' }

    describe "for signed-out users" do
      it { should have_link("Sign up") }
    end

    describe "for signed-in users" do
      create_user
      before do
        sign_in user
      end

      it "should render the user's feed" do
        FactoryGirl.create(:post, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:post, user: user, content: "Dolor sit amet")
        visit root_path

        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should show pluralized post count" do
        visit root_path
        page.should have_selector("span", :content => user.posts.count.to_s+" posts")
        FactoryGirl.create(:post, user: user, content: "Lorem ipsum")
        visit root_path
        page.should have_selector("span", :content => user.posts.count.to_s+" post")
        FactoryGirl.create(:post, user: user, content: "Dolor sit amet")
        visit root_path
        page.should have_selector("span", :content => user.posts.count.to_s+" posts")
      end
    end
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

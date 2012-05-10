require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe "profile page" do
    create_user
    before { visit user_path(user) }
    
    it { should have_heading user.name }
    it { should have_title   user.name }
  end
  
  describe "signup page" do
    before { visit signup_path }
    
    it { should have_heading    'Sign Up' }
    it { should have_full_title 'Sign Up' }
  end
  
  describe "signup" do
    
    before { visit signup_path }
    
    let(:submit) { "Create my account" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "error messages" do
        before { click_button submit }
        
        it { should have_title 'Sign Up' }
        it { should have_error_message }
        it { should have_error_explanation }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
        
        it { should have_title user.name }
        it { should have_success_message 'Welcome' }
        it { should have_link 'Sign out' }
      end
    end
  end
end

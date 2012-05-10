require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_heading 'Sign in' }
    it { should have_title   'Sign in' }
  end
  
  describe "signin" do
    before { visit signin_path }
    
    describe "with invalid information" do
      create_user
      before { invalid_signin(user) }
      
      it { should have_title 'Sign in' }
      it { should have_error_message 'Invalid' }
      it { should have_field('Email', :with => user.email) }
      specify { find_field('Remember Me').should be_checked }
      
      it { should_not have_link('Profile', href: user_path(user)) }
      it { should_not have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign out', href: signout_path) }
      it { should have_link('Sign in', href: signin_path) }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_error_message }
      end
    end
    
    describe "with valid information" do
      create_user
      before do
        user.email = user.email.upcase # ensures case-insensitivity
        valid_signin(user)
      end
      
      it { should have_title user.name }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link 'Sign in' }
      end
    end
  end
  
  describe "authorization" do
    
    describe "for non-signed-in users" do
      create_user
      
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title 'Sign in' }
          it { should have_notice_message 'sign in' }
        end
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
    
    describe "as wrong user" do
      create_user
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_full_title 'Edit user' }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end

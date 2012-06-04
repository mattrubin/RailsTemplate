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

      it { should_not have_link('Users',    href: users_path) }
      it { should_not have_link('Profile',  href: user_path(user)) }
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
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
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

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_title 'Edit user'
          end

          describe "when signing in again" do
            before do
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name)
            end
          end

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

    describe "for signed-in users" do
      create_user
      before { sign_in user }

      describe "visiting Users#new page" do
        before { visit signup_path }
        specify { current_url.should == root_url }
      end

      describe "submitting a POST request to the Users#create action" do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      create_user
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }

      describe "attempting to DELETE self" do
        specify "should redirect to root" do
          delete user_path(admin)
          response.should redirect_to(root_path)
        end
        it "should not be possible" do
          expect { delete user_path(admin) }.not_to change(User, :count)
        end

      end
    end

  end
end

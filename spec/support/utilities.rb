include ApplicationHelper

def create_user
  let(:user) { FactoryGirl.create(:user) }
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  check "Remember Me"
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def invalid_signin(user)
  user.email = nil
  valid_signin(user)
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_error_explanation do
  match do |page|
    page.should have_selector '#error_explanation'
  end
end

RSpec::Matchers.define :have_title do |message|
  match do |page|
    page.should have_selector('title', text: message)
  end
end

RSpec::Matchers.define :have_full_title do |message|
  match do |page|
    page.should have_title(full_title(message))
  end
end

RSpec::Matchers.define :have_heading do |message|
  match do |page|
    page.should have_selector('h1', text: message)
  end
end

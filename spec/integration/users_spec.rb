require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_url
          click_button
          response.should render_template('users/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(User, :count)
      end
    end
    describe "succcess" do
      it "should make a new user" do
        lambda do
          visit signup_url
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          # or fill_in :user_name if you don't use labels
          click_button
          response.should render_template('users/show.html.erb')
          response.should have_tag("div.flash.success")
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in "Email",    :with => ""
        fill_in "Password", :with => ""
        click_button
        response.should render_template('sessions/new')
        response.should have_tag("div.flash.error", /invalid/i)
      end
    end

    
    describe "success" do
      it "should sign an user in and out" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "sign in/out/in" do
    it "should sign an user in, out and in again" do
      user = Factory(:user)
      integration_sign_in(user)
      controller.should be_signed_in
      click_link "Sign out"
      controller.should_not be_signed_in
      click_link "Sign in"
      integration_sign_in(user)
      controller.should be_signed_in
    end
  end 
  
end

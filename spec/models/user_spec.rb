# == Schema Information
# Schema version: 20100421160024
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attributes = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  # it should
  # - Have, Accept, Require, Reject, Confirm, Set, Get...

  it "should create a new instance given valid attributes" do
    User.create!(@attributes)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attributes.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attributes.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject a name longer than 50 characters" do
    long_name = "a" * 51
    long_name_user = User.new(@attributes.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w(user@foo.com THE_USER@foo.bar.org first.last@foo.nl)
    addresses.each do |address|
      valid_email_user = User.new(@attributes.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w(user@foo,com THE_USER.org example.user@foo.)
    addresses.each do |address|
      invalid_email_user = User.new(@attributes.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database
    User.create!(@attributes)
    user_with_duplicate_email = User.new(@attributes)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject duplicate email addresses identically up to case" do
    upcase_email = @attributes[:email].upcase
    User.create!(@attributes.merge(:email => upcase_email))
    user_with_duplicate_email = User.new(@attributes)
    user_with_duplicate_email.should_not be_valid
  end

  
  describe "password confirmation" do
    
    it "should require a password" do
      User.new(@attributes.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a password_confirmation" do
      User.new(@attributes.merge(:password => "foobar", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password" do
      User.new(@attributes.merge(:password_confirmation => "invalid")).should_not be_valid 
    end
    
    it "should reject short passwords" do
      short_password = "x" * 5
      hash = @attributes.merge(:password => short_password, :password_confirmation => short_password)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long_password = "x" * 41
      hash = @attributes.merge(:password => long_password, :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
        
    before(:each) do
      @user = User.create!(@attributes)
    end
  
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
  
    it "should set the encrypted password before it saves" do
      @user.encrypted_password.should_not be_blank
    end
    
    
    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attributes[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end      
    end
    
    
    describe "autenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attributes[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attributes[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attributes[:email], @attributes[:password])
        matching_user.should == @user
      end
      
      
    end
    
  end
  
  
  
end

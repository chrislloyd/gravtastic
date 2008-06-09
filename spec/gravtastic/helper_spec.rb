require File.dirname(__FILE__) + '/../spec_helper.rb'
require 'erb'
# require 'active_support'

include Gravtastic::Helpers, ERB::Util

describe "Gravtastic::Helpers" do
  before(:each) do
    @user = mock('User')
    @user.class.send(:include, Gravtastic::Model)
    @user.class.has_gravatar
    @user.stub!(:email).and_return('joe@example.com')
  end
  
  describe "gravatar_path" do

    it "returns a gravatar path for a class" do
      gravatar_path(@user).should == 'http://gravatar.com/avatar/12313'
    end
    
  end
  
  
  
end
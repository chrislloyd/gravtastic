require File.dirname(__FILE__) + '/spec_helper'
require 'digest/md5'

describe "Gravtastic::Model" do

  before(:each) do
    @user = mock('User')
    @user.class.send(:include, Gravtastic::Model)
  end

  describe "class" do

    before(:each) do
      @klass = @user.class
    end

    it "doesn't have a gravatar source if it hasn't been set" do
      @klass.gravatar_source.should == nil
    end

    it "sets the gravatar source to email by default" do
      @klass.has_gravatar
      @klass.gravatar_source.should == :email
    end

    it "sets the gravatar source to the value of :on supplied" do
      @klass.has_gravatar :on => :other_method
      @klass.gravatar_source.should == :other_method
    end

  end


  describe "instance with a set gravatar" do

    before(:each) do
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
      @user.class.has_gravatar
    end
    
    it "has a gravatar" do
      @user.class.should have_gravatar
    end

    it "returns a gravatar_id if the Gravatar source is set" do
      @user.gravatar_id.should_not be_nil
    end

    it "changes the gravatar_id when the Gravatar source is changed" do
      lambda {
        @user.class.has_gravatar :on => :name
      }.should change(@user, :gravatar_id)
    end

    it "returns a hash" do
      @user.gravatar_id.should == Digest::MD5.hexdigest('joe@example.com')
    end
    
    it "has a gravatar_url" do
      @user.gravatar_url.should_not be_nil
    end

  end
  
  describe "instance without a set gravatar" do
    
    before(:each) do
      @user.class.has_gravatar :on => nil
    end
    
    it "doesn't have a gravatar" do
      @user.class.should_not have_gravatar
    end
    
    it "doesn't have a gravatar_id" do
      @user.gravatar_id.should be_nil
    end
    
    it "doesn't have a gravatar_url" do
      @user.gravatar_url.should be_nil
    end
  end
  
  describe "#gravatar_url" do
    
    before(:each) do
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
      @user.class.has_gravatar
    end
    
    it "is not nil when gravatar_id is set" do
      @user.gravatar_url.should_not be_nil
    end
    
    it "returns a valid URL" do
      @user.gravatar_url.should == 'http://www.gravatar.com/f5b8fb60c6116331da07c65b96a8a1d1'
    end
    
    it "returns a valid URL with a width" do
      @user.gravatar_url(:width => 512).should == 'http://www.gravatar.com/f5b8fb60c6116331da07c65b96a8a1d1?width=512'
    end
    
    it "returns a valid URL with a height" do
      @user.gravatar_url(:height => 512).should == 'http://www.gravatar.com/f5b8fb60c6116331da07c65b96a8a1d1?height=512'
    end
    
    it "returns a valid URL with a width and a height" do
      @user.gravatar_url(:width => 800, :height => 600).should == 'http://www.gravatar.com/f5b8fb60c6116331da07c65b96a8a1d1?width=800&height=600'
    end
    
  end
  
end
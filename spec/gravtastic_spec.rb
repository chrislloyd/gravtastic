require File.dirname(__FILE__) + '/spec_helper.rb'
require 'digest/md5'

# Time to add your specs!
# http://rspec.info/
describe "Gravtastic::Model" do
  
  describe "class methods" do
  
    before(:each) do
      @user = mock('User').class
      @user.send(:include, Gravtastic::Model)
    end
  
    it "doesn't have a gravatar source before it is set" do
      @user.gravatar_source.should == nil
    end
  
    it "sets the gravatar source to email by default" do
      @user.has_gravatar
      @user.gravatar_source.should == :email
    end
  
    it "sets the gravatar source to the value of the on key supplied" do
      @user.has_gravatar :on => :other_method
      @user.gravatar_source.should == :other_method
    end
    
  end
  
  describe "instance methods" do
    
    before(:each) do
      @user = mock('User')
      @user.class.send(:include, Gravtastic::Model)
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
    end
    
    it "doesn't have a gravatar" do
      @user.should_not have_gravatar
    end
    
    it "doesn't include other instance methods if the gravatar_source is not set" do
      @user.should_not respond_to(:gravatar_id)
    end
    
    it "includes other instance methods if the gravatar_source is set" do
      @user.class.has_gravatar
      @user.should respond_to(:gravatar_id)
    end
    
    it "returns a gravatar_id if the gravatar_source is set" do
      @user.class.has_gravatar
      @user.gravatar_id.should_not be_nil
    end
    
    it "changes the gravatar_id when the gravatar_source is changed" do
      @user.class.has_gravatar
      lambda {
        @user.class.has_gravatar :on => :name
      }.should change(@user, :gravatar_id)
    end
    
    it "returns an md5 hash of the gravatar_source" do
      hash = Digest::MD5.hexdigest('joe@example.com')
      @user.class.has_gravatar
      @user.gravatar_id.should == hash
    end
    
  end
  
  
end

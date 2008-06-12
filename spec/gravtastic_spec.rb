require File.dirname(__FILE__) + '/spec_helper'

describe "Gravtastic::Model" do

  before(:each) do
    @user = mock('User')
    @user.class.send(:include, Gravtastic::Model)
    @klass = @user.class
  end
  
  describe ".gravatar_source" do
    
    it "is nil if unset" do
      @klass.gravatar_source.should be_nil
    end
  
  end
  
  describe ".has_gravatar" do
    
    it "sets .gravatar_source to email by default" do
      @klass.has_gravatar
      @klass.gravatar_source.should == :email
    end
    
    it "changes .gravatar_source" do
      lambda {
        @klass.has_gravatar :on => :other_method
      }.should change(@klass, :gravatar_source)
    end
    
    it "sets .gravatar_source to the value of :on" do
      @klass.has_gravatar :on => :other_method
      @klass.gravatar_source.should == :other_method
    end
    
  end

  describe ".has_gravatar?" do
    
    it "is true when .gravatar_source is not nil" do
      @user.class.stub!(:gravatar_source).and_return(:email)
      @user.class.should have_gravatar
    end
    
    it "is false when .gravatar_soruce is not is nil" do
      @user.class.stub!(:gravatar_source).and_return(nil)
      @user.class.should_not have_gravatar
    end
    
  end

  describe "#gravatar_id" do

    before(:each) do
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
      @user.class.stub!(:gravatar_source).and_return(:email)
    end
    
    it "is not nil when .gravatar_source is not nil" do
      @user.gravatar_id.should_not be_nil
    end
    
    it "is nil when .gravatar_source is nil" do
      @user.class.stub!(:gravatar_source).and_return(nil)
      @user.gravatar_id.should be_nil
    end

    it "changes when .gravatar_source is changed" do
      lambda {
        @user.class.stub!(:gravatar_source).and_return(:name)
      }.should change(@user, :gravatar_id)
    end

    it "is a MD5 hash" do
      @user.gravatar_id.should == 'f5b8fb60c6116331da07c65b96a8a1d1'
    end
    
    it "downcases any imput" do
      @user.stub!(:email).and_return('JOE@EXAMPLE.COM')
      @user.gravatar_id.should == 'f5b8fb60c6116331da07c65b96a8a1d1'
    end
    
  end
  
  describe "#gravatar_url" do
    
    before(:each) do
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
      @user.class.stub!(:gravatar_source).and_return(:email)
    end
    
    it "is not nil when .gravatar_source is not nil" do
      @user.gravatar_url.should_not be_nil
    end
    
    it "is nil when .gravatar_source is nil" do
      @user.class.stub!(:gravatar_source).and_return(nil)
      @user.gravatar_url.should be_nil
    end
    
    it "always specifies a png resource type" do
      @user.gravatar_url.should match(/.png/)
    end
    
    it "returns a valid gravatar URL" do
      @user.gravatar_url.should == valid_gravatar_url + '?r=PG'
    end
    
    it "returns a valid gravatar URL even when invalid option is passed" do
      @user.gravatar_url(:foo => :bar).should == valid_gravatar_url + '?r=PG'
    end
    
    it "parses a size" do 
      @user.gravatar_url(:size => 512).should == valid_gravatar_url + '?r=PG&s=512'
    end
    
    it "parses a rating" do 
      @user.gravatar_url(:rating => 'MA').should == valid_gravatar_url + '?r=MA'
    end
    
    it "returns a valid gravatar URL when the rating option is unescaped" do
      @user.gravatar_url(:rating => 'Unescaped String').should == valid_gravatar_url + '?r=Unescaped+String'
    end
    
    it "parses a default image type" do 
      @user.gravatar_url(:default => :identicon).should == valid_gravatar_url + '?d=identicon&r=PG'
    end
    
    it "parses a default image URL" do 
      @user.gravatar_url(:default => 'http://example.com/images/example.jpg').should == valid_gravatar_url + '?d=http%3A%2F%2Fexample.com%2Fimages%2Fexample.jpg&r=PG'
    end
    
    it "parses multiple options" do
      @user.gravatar_url(:size => 20, :rating => 'R18', :default => :monsterid).should == valid_gravatar_url + '?d=monsterid&r=R18&s=20'
    end
    
    it "defaults to a 'PG' rating" do
      @user.gravatar_url(:rating => 'PG').should == @user.gravatar_url
    end
    
    def valid_gravatar_url # :nodoc:
      'http://www.gravatar.com/avatar/f5b8fb60c6116331da07c65b96a8a1d1.png'
    end
    
  end
  
end
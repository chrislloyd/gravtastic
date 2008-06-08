require File.dirname(__FILE__) + '/../spec_helper.rb'
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
  
  describe "instance" do
    
    before(:each) do
      @user.stub!(:email).and_return('joe@example.com')
      @user.stub!(:name).and_return('Joe Bloggs')
    end
    
    describe "with Gravatar source" do
      
      before(:each) do
        @user.class.has_gravatar
      end
      
      it "has a gravatar" do
        @user.should have_gravatar
      end
      
      it "responds to :gravatar_id" do
        @user.should respond_to(:gravatar_id)
      end

      it "returns a gravatar_id if the Gravatar source is set" do
        @user.gravatar_id.should_not be_nil
      end

      it "changes the gravatar_id when the Gravatar source is changed" do
        lambda {
          @user.class.has_gravatar :on => :name
        }.should change(@user, :gravatar_id)
      end

      it "returns a MD5 hash" do
        @user.gravatar_id.should == Digest::MD5.hexdigest('joe@example.com')
      end
      
      it "should get the value of the Gravatar source when calculating the gravatar_id" do
        @user.should_receive(:email).once.and_return('joe@example.com')
        @user.gravatar_id
      end
      
    end
    
    describe "without Gravatar source" do
      
      before(:each) do
        @user.class.has_gravatar :on => nil
      end

      it "doesn't have a gravatar" do
        @user.should_not have_gravatar
      end

      it "doesn't include other instance methods" do
        @user.should_not respond_to(:gravatar_id)
      end

    end
    
  end
  
end

require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/gravtastic'

describe Gravtastic do

  before(:each) do
    @g = Class.new do |c|
      c.send(:include, Gravtastic)
      c.is_gravtastic
    end
  end

  describe ".is_gravtastic" do

    it "includes the methods" do
      @g.included_modules.should include(Gravtastic::InstanceMethods)
    end

  end

  describe 'default' do

    it "options are {:rating => 'PG', :secure => false, :filetype => :png}" do
      @g.gravatar_defaults.should == {:rating => 'PG', :secure => false, :filetype => :png}
    end

    it "source is :email" do
      @g.gravatar_source.should == :email
    end

  end

  describe "#gravatar_id" do

    it "downcases email" do
      a = @g.new
      stub(a).email{ 'USER@EXAMPLE.COM' }
      b = @g.new
      stub(b).email{ 'user@example.com' }
      a.gravatar_id.should == b.gravatar_id
    end

  end

  describe "#gravatar_url" do

    before(:each) do
      @user = @g.new
      stub(@user).email{ 'user@example.com' }
    end

    it "makes a pretty URL" do
      @user.gravatar_url.should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=PG'
    end

    it "makes a secure URL" do
      @user.gravatar_url(:secure => true).should == 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=PG'
    end

    it "makes a jpeggy URL" do
      @user.gravatar_url(:filetype => :jpg).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.jpg?r=PG'
    end

    it "makes a saucy URL" do
      @user.gravatar_url(:rating => 'R').should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=R'
    end

    it "abides to some new fancy feature" do
      @user.gravatar_url(:extreme => true).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?extreme=true&amp;r=PG'
    end

    it "makes a URL from the defaults" do
      stub(@user.class).gravatar_defaults{ {:size => 20, :rating => 'R18', :secure => true, :filetype => :png} }
      @user.gravatar_url.should == 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=R18&amp;s=20'
    end

  end

end
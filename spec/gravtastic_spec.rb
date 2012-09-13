require "helper.rb"

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

    it "options are {:rating => 'PG', :secure => true, :filetype => :png}" do
      @g.gravatar_defaults.should == {
        :rating => 'PG',
        :secure => true,
        :filetype => :png,
      }
    end

    it "source is :email" do
      @g.gravatar_source.should == :email
    end

  end

  describe "#gravatar_id" do

    it "downcases email" do
      a = @g.new
      stub(a).email do 'USER@EXAMPLE.COM' end
      b = @g.new
      stub(b).email do 'user@example.com' end
      a.gravatar_id.should == b.gravatar_id
    end

  end

  describe "#gravatar_url" do

    before(:each) do
      @user = @g.new
      stub(@user).email{ 'user@example.com' }
    end

    it "makes a pretty URL" do
      @user.gravatar_url(:secure => false).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=PG'
    end

    it "makes a secure URL" do
      @user.gravatar_url.should == 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=PG'
    end

    it "makes a jpeggy URL" do
      @user.gravatar_url(:secure => false, :filetype => :jpg).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.jpg?r=PG'
    end

    it "makes a saucy URL" do
      @user.gravatar_url(:secure => false, :rating => 'R').should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=R'
    end

    it "makes a forcedefault URL" do
      @user.gravatar_url(:secure => false, :forcedefault => true).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?f=y&r=PG'
    end

    it "abides to some new fancy feature" do
      @user.gravatar_url(:secure => false, :extreme => true).should == 'http://gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?extreme=true&r=PG'
    end

    it "makes a URL from the defaults" do
      stub(@user.class).gravatar_defaults{ {:size => 20, :rating => 'R18', :secure => true, :filetype => :png} }
      @user.gravatar_url.should == 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=R18&s=20'
    end

  end

end

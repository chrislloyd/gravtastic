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
      @g.gravatar_defaults.should == {:rating => 'PG', :secure => true, :filetype => :png}
    end

    it "source is :email" do
      @g.gravatar_source.should == :email
    end

  end

  describe "#gravatar_id" do

    it 'should delegate to Gravtastic.gravatar_id' do
      a = @g.new
      stub(a).email do 'user@example.com' end
      mock(Gravtastic).gravatar_id('user@example.com') { 'email_hash' }
      a.gravatar_id.should == 'email_hash'
    end
    
  end
  
  describe "Gravtastic.gravatar_id" do

    it "downcases email" do
      Gravtastic.gravatar_id('USER@EXAMPLE.COM').should == Gravtastic.gravatar_id('user@example.com')
    end

    it "hashes with MD5" do
      Gravtastic.gravatar_id('user@example.com').should == 'b58996c504c5638798eb6b511e6f49af'
    end

  end  

  describe "#gravatar_url" do

    before(:each) do
      @user = @g.new
      stub(@user).email{ 'user@example.com' }
    end

    it "makes a pretty URL" do
      @user.gravatar_url.should == 'https://secure.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af.png?r=PG'
    end

    it "delegates to Gravtastic.gravatar_url" do
      stub(@user.class).gravatar_defaults{ { :some => :default, :awesome => 'values' } }
      mock(Gravtastic).gravatar_url('user@example.com', { :some => :default, :awesome => 'override', :extreme => true }){ 'http://magic.url' }
      @user.gravatar_url(:extreme => true, :awesome => 'override').should == 'http://magic.url'
    end

  end
  
  describe "Gravtastic.gravatar_url" do

    before(:each) do
      stub(Gravtastic).gravatar_id('email'){ 'mailhash' }
    end

    it "makes a secure URL" do
      Gravtastic.gravatar_url('email', :rating => 'PG', :secure => true, :filetype => :png).should == 'https://secure.gravatar.com/avatar/mailhash.png?r=PG'
    end

    it "makes an unsecure URL" do
      Gravtastic.gravatar_url('email', :rating => 'PG', :secure => false, :filetype => :png).should == 'http://gravatar.com/avatar/mailhash.png?r=PG'
    end

    it "makes a jpeggy URL" do
      Gravtastic.gravatar_url('email', :rating => 'PG', :secure => true, :filetype => :jpg).should == 'https://secure.gravatar.com/avatar/mailhash.jpg?r=PG'
    end

    it "makes a saucy URL" do
      Gravtastic.gravatar_url('email', :rating => 'R', :secure => true, :filetype => :png).should == 'https://secure.gravatar.com/avatar/mailhash.png?r=R'
    end

    it "abides to some new fancy feature" do
      Gravtastic.gravatar_url('email', :rating => 'PG', :secure => true, :filetype => :png, :extreme => true).should == 'https://secure.gravatar.com/avatar/mailhash.png?extreme=true&r=PG'
    end

  end

end
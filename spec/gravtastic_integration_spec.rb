require 'active_record'
require 'dm-core'
require 'sequel'
require 'mongo_mapper'
require 'mongoid'
require 'gravtastic'

describe ActiveRecord do
  it "includes Gravtastic" do
    ActiveRecord::Base.should respond_to(:is_gravtastic)

    # Class.new(ActiveRecord::Base) do
    #   is_gravtastic
    # end.new.should respond_to(:gravatar_url)
  end
end

describe DataMapper do
  it "includes Gravtastic" do
    Class.new do
      include DataMapper::Resource
      is :gravtastic
    end.new.should respond_to(:gravatar_url)
  end
end

describe Sequel do
  it "includes Gravtastic" do
    Sequel::Model.plugin Gravtastic
    # Class.new(Sequel::Model) do
    #   plugin Gravtastic      
    # end.new.should respond_to(:gravatar_url)
  end
end

describe MongoMapper do
  it "includes Gravtastic" do
    Class.new do
      include MongoMapper::Document
      plugin Gravtastic
    end.new.should respond_to(:gravatar_url)
  end
end

describe Mongoid do
  it "includes Gravtastic" do
    Class.new do
      include Mongoid::Document
      include Gravtastic
      is_gravtastic
    end.new.should respond_to(:gravatar_url)
  end
end

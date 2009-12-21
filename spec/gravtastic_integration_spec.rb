require File.dirname(__FILE__) + '/spec_helper'
require 'rubygems'

require 'active_record'
# require 'dm-core'
require 'gravtastic'


# class User
#   include DataMapper::Resource
#   is_gravtastic
# end

describe ActiveRecord::Base do

  it "includes Gravtastic" do
    ActiveRecord::Base.included_modules.should include(Gravtastic)
  end

  it "responds to .is_gravtastic" do
    ActiveRecord::Base.should respond_to(:is_gravtastic)
  end

end

# describe DataMapper::Resource do
#
#   it "includes Gravtastic::Resource" do
#     User.included_modules.should include(Gravtastic)
#   end
#
#   it "responds to .is_gravtastic" do
#     User.should respond_to(:is_gravtastic)
#   end
#
# end



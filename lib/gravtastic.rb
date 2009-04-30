$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'digest/md5'
require 'cgi'
require 'uri'

# = Gravtastic - Easily add Gravatars to your Ruby objects.
# 
# Copyright (C) 2008 mailto:christopher.lloyd@gmail.com
# 
# == Example
# 
# Somewhere in your application you need to <tt>require 'gravtastic'</tt>. In Rails >= 2.1 you can forego this and just add a dependency gem dependency for Gravtastic.
# 
#   config.gem 'gravtastic'
# 
# If you are using Merb & DataMapper you can add do the same by adding the following to your init.rb file:
# 
#   dependency 'gravtastic'
# 
# Make sure you add this after either the <tt>use_orm :datamapper</tt> line or after a DataMapper extension. The next step is to give your model a Gravatar:
# 
#   class User
#     is_gravtastic
#   end
# 
# If you are using a standard Ruby class you have to add the line <tt>include Gravtastic::Resource</tt> before <tt>is_gravtastic</tt>.
#   
# This defaults to looking for the gravatar ID on the <tt>email</tt> method. So, if your <tt>User</tt> has an <tt>email</tt> then it will send that to Gravatar to get their picture. You can change the default gravatar source like this:
# 
#   is_gravtastic :with => :author_email
# 
# Now, you can access your object's gravatar with the <tt>gravatar_url</tt> method:
# 
#   current_user.gravatar_url
#   => "http://gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?r=PG"
# 
# Note that it defaults to a PG rating. You can specify extra options with a hash:
# 
#   current_user.gravatar_url(:rating => 'R18', :size => 512)
#   => "http://gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?r=R18&s=512"
#   
#   current_user.gravatar_url(:secure => true)
#   => "https://secure.gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?r=PG"
#   
# However, to DRY things up you can specify defaults in the class declaration.
# 
#   is_gravtastic :with => :author_email, :rating => 'R18', :size => 20
# 
# Nice, now all the calls to gravatar_url will have the defaults you have specified. Any options that you pass when you use <tt>gravatar_url</tt> will over-ride these class-defaults.
# 
module Gravtastic
  
  def self.included(base)
    base.extend(SingletonMethods)
  end
  
  module SingletonMethods
    
    def is_gravtastic(source = :email, options={})
      extend ClassMethods
      include InstanceMethods
      
      @gravatar_source = source
      @gravatar_defaults = {
        :rating => 'PG',
        :secure => false,
        :filetype => :png
      }.merge(options)
    end
    
    alias :has_gravatar :is_gravtastic
  
  end
  
  module ClassMethods
    
    # attr_reader :gravatar_source, :gravatar_defaults
    
    def gravatar_source
      @gravatar_source
    end
    
    def gravatar_defaults
      @gravatar_defaults
    end
    
  end
  
  module InstanceMethods
    
    def gravatar_id
      Digest::MD5.hexdigest(send(self.class.gravatar_source).to_s.downcase)
    end
    
    def gravatar_url(options={})      
      options = self.class.gravatar_defaults.merge(options)
      gravatar_hostname(options.delete(:secure)) +
        gravatar_filename(options.delete(:filetype)) +
        url_params_from_hash(options)
    end
    
  private
    
    def url_params_from_hash(hash)
      '?' + options.map do |pair|
        pair.first = pair.first.to_s[0,1]
        pair.map{|item| item = CGI::escape(item.to_s) }.join('=')
      end.sort.join('&')
    end
    
    def gravatar_hostname(secure)
      'http' + (secure ? 's://secure.' : '://') + 'gravatar.com/avatar/'
    end
    
    def gravatar_filename(filetype)
      "#{gravatar_id}.#{filetype}"
    end
    
  end
  
end

ActiveRecord::Base.send(:include, Gravtastic) if defined?(ActiveRecord) # :nodoc:
DataMapper::Resource.append_inclusions(Gravtastic) if defined?(DataMapper) # :nodoc:

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'digest/md5'
require 'cgi'

# = Gravtastic - Easily add Gravatars to your Ruby objects.
# 
# Copyright (C) 2008 mailto:christopher.lloyd@gmail.com
# 
# == Example
# 
# Somewhere in your application you need to <tt>require 'gravtastic'</tt>. In Rails >= 2.1 you can forego this and just add a dependency gem dependency for Gravtastic.
# 
#     config.gem 'gravtastic', :source => 'http://gems.github.com/'
# 
# The next step is to give your model a Gravatar:
# 
#   class User
#     has_gravatar
#   end
# 
# If you are using a standard Ruby class or Datamapper resource you have to add the line <tt>include Gravtastic::Model</tt> before <tt>has_gravatar</tt>.
# 
# This defaults to looking for the gravatar ID on the <tt>email</tt> method. So, if your <tt>User</tt> has an <tt>email</tt> then it will send that to Gravatar to get their picture. You can change the default gravatar source like this:
# 
#   has_gravatar :on => :author_email
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
module Gravtastic
  module Model

    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      # 
      # Sets the gravatar_source. Basically starts this whole shindig.
      # 
      # Examples:
      # 
      #   has_gravatar
      # 
      #   has_gravatar :on => :author_email
      # 
      #   has_gravatar :defaults => { :rating => 'R18' }
      # 
      def has_gravatar(options={:on => :email})
        @gravatar_source = options[:on]
        options[:defaults] ||= {}
        @gravatar_defaults = {:rating => 'PG', :secure => false}.merge(options[:defaults])
      end

      # 
      # Returns a symbol of the instance method where the Gravatar is pulled from.
      # 
      # For example, if your users email is returned by the method <tt>#gobagaldy_gook</tt> then it
      # will return the symbol <tt>:'gobagaldy_gook'</tt>.
      # 
      def gravatar_source
        @gravatar_source
      end
      
      # 
      # Returns a hash of all the default gravtastic options.
      # 
      def gravatar_defaults
        @gravatar_defaults
      end
      
      # 
      # Returns <tt>true</tt> if the gravatar_source is set. <tt>false</tt> if not. Easy!
      # 
      def has_gravatar?
        !!gravatar_source
      end

    end

    # 
    # The raw MD5 hash used by Gravatar, generated from the ClassMethods#gravatar_source.
    # 
    def gravatar_id
      if self.class.gravatar_source && value = send(self.class.gravatar_source)
        @gravatar_id = Digest::MD5.hexdigest(value.to_s.downcase)
      end
    end

    # 
    # Returns a string with the URL for the instance's Gravatar.
    # 
    # It defaults to <tt>:rating => 'PG'</tt> and <tt>:secure => false</tt>
    # 
    # Examples:
    # 
    #   current_user.gravatar_url
    #   => "http://gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?r=PG"
    # 
    #   current_user.gravatar_url(:rating => 'R18', :size => 512, :default => 'http://example.com/images/example.jpg')
    #   => "http://gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?d=http%3A%2F%2Fexample.com%2Fimages%2Fexample.jpg&r=R18&s=512"
    # 
    #   current_user.gravatar_url(:secure => true)
    #   => "https://secure.gravatar.com/e9e719b44653a9300e1567f09f6b2e9e.png?r=PG"
    # 
    def gravatar_url(options={})      
      options = self.class.gravatar_defaults.merge(options)
      
      @gravatar_url = gravatar_url_base(options[:secure]) + gravatar_filename + parse_url_options_hash(options)
    end

    private
    
    GRAVTASTIC_VALID_PARAMS = [:size, :rating, :default]
    
    def parse_url_options_hash(options)
      
      options.delete_if { |key,_| ![:size,:rating,:default].include?(key) }
      
      unless options.empty?
        '?' + options.map do |pair|
          pair[0] = pair[0].to_s[0,1] # Get the first character of the option
          pair.map{|item| item = CGI::escape(item.to_s) }.join('=') # Join key & value together
        end.sort.join('&') # Join options together
      else
        ''
      end
    end
    
    def gravatar_url_base(secure)
      'http' + (secure ? 's://secure.' : '://') + 'gravatar.com/avatar/'
    end
    
    def gravatar_filename
      if gravatar_id
        gravatar_id + '.png'
      else
        ''
      end
    end
    
  end
end

ActiveRecord::Base.send(:include, Gravtastic::Model) if defined?(ActiveRecord) # :nodoc:

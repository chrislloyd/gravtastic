$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'digest/md5'
require 'cgi'

module Gravtastic
  module Model

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def has_gravatar(options={:on => :email})
        @gravatar_source = options[:on]
      end

      def gravatar_source
        @gravatar_source
      end

      def has_gravatar?
        !!gravatar_source
      end

    end

    def gravatar_id
      if self.class.gravatar_source && value = send(self.class.gravatar_source).downcase
        @gravatar_id = Digest::MD5.hexdigest(value.to_s)
      end
    end

    def gravatar_url(options={})
      options[:rating] ||= 'PG'
      if gravatar_id
        @gravatar_url = 'http://www.gravatar.com/avatar/' + gravatar_id + '.jpg' + parse_url_options_hash(options)
      end
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

  end
end

# ActiveRecord::Base.send(:extend, )
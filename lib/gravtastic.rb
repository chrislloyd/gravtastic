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
        !!@gravatar_source
      end

    end

    def gravatar_id
      if self.class.gravatar_source && value = send(self.class.gravatar_source)
        @gravatar_id = Digest::MD5.hexdigest(value.to_s)
      end
    end

    def gravatar_url(options={})
      if gravatar_id
        @gravatar_url = File.join('http://www.gravatar.com', gravatar_id) + parse_url_options_hash(options)
      end
    end

    private

    def parse_url_options_hash(options)
      unless options.empty?
        # What a 1 liner!
        '?' + options.to_a.map{|pair| pair.map{|item| item = CGI::escape(item.to_s) }.join('=') }.join('&')
      else
        ''
      end
    end

  end
end

# ActiveRecord::Base.send(:extend, )
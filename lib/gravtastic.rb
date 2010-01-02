require 'digest/md5'
require 'cgi'
require 'uri'

module Gravtastic

  def self.included(base)
    base.extend(SingletonMethods)
  end

  def self.version
    File.read(__FILE__.sub('lib/gravtastic.rb','VERSION')).strip
  end

  module SingletonMethods

    def is_gravtastic(*args)
      extend ClassMethods
      include InstanceMethods

      options = args.last.is_a?(Hash) ? args.pop : {}
      source = args.first || :email

      @gravatar_defaults = {
        :rating => 'PG',
        :secure => false,
        :filetype => :png
      }.merge(options)
      @gravatar_source = source
    end

    alias_method :has_gravatar, :is_gravtastic
    alias_method :is_gravtastic!, :is_gravtastic

  end

  module ClassMethods

    def gravatar_source
      @gravatar_source
    end

    def gravatar_defaults
      @gravatar_defaults
    end

    def gravatar_options
      { :size => 's',
        :default => 'd',
        :rating => 'r'
      }
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
      '?' + hash.map do |key, val|
        [self.class.gravatar_options[key.to_sym] || key.to_s, CGI::escape(val.to_s) ].join('=')
      end.sort.join('&amp;')
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
MongoMapper::Document.append_inclusions(Gravtastic) if defined?(MongoMapper) && MongoMapper::Document.respond_to?(:append_inclusions) # :nodoc:

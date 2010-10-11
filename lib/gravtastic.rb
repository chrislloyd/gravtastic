require 'digest/md5'
require 'cgi'
require 'uri'

module Gravtastic

  def self.version
    File.read(__FILE__.sub('lib/gravtastic.rb','VERSION')).strip
  end
  
  def self.included(model)
    model.extend ManualConfigure
  end
  
  def self.apply(model, *args, &blk)
  end
  
  def self.configure(model, *args, &blk)
    options = args.last.is_a?(Hash) ? args.pop : {}

    model.gravatar_defaults = {
      :rating => 'PG',
      :secure => false,
      :filetype => :png
    }.merge(options)
    
    model.gravatar_source = args.first || :email
  end

  module ManualConfigure
    def is_gravtastic(*args, &blk)
      extend ClassMethods
      include InstanceMethods
      Gravtastic.configure(self, *args, &blk)
      self
    end

    alias_method :has_gravatar, :is_gravtastic
    alias_method :is_gravtastic!, :is_gravtastic
  end

  module ClassMethods
    attr_accessor :gravatar_source, :gravatar_defaults

    def gravatar_abbreviations
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
        [self.class.gravatar_abbreviations[key.to_sym] || key.to_s, CGI::escape(val.to_s) ].join('=')
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

# All these ORMs suck balls. See Sequel or MongoMapper for examples of good
# plugin systems.

ActiveRecord::Base.send(:include, Gravtastic) if defined?(ActiveRecord) # :nodoc:
DataMapper::Model.append_extensions(Gravtastic::ManualConfigure) if defined?(DataMapper) # :nodoc:
Mongoid::Document.included do
  include Gravtastic
end if defined?(Mongoid) # :nodoc:

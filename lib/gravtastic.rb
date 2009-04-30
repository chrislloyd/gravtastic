$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'digest/md5'
require 'cgi'
require 'uri'

module Gravtastic

  def self.included(base)
    base.extend(SingletonMethods)
  end

  module SingletonMethods

    def is_gravtastic(source = :email, options={})
      extend ClassMethods
      include InstanceMethods

      @gravatar_defaults = {
        :rating => 'PG',
        :secure => false,
        :filetype => :png
      }.merge(options)
      @gravatar_source = source
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
      '?' + hash.map do |pair|
        pair[0] = pair[0].to_s[0,1]
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

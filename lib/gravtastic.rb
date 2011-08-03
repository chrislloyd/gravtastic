# Gravtastic is a small module which quickly generates a Gravatar URL. Just
# include in your class!

# Gravatar uses an MD5 hash of the users email to locate their avatar.
require 'digest/md5'
require 'gravtastic/version'

begin
  require 'rails'
  require 'gravtastic/engine'
rescue LoadError
end

module Gravtastic

  # When you `include Gravtastic`, Ruby automatically calls this method
  # with the class you called it in. It allows us extend the class with the
  # `#gravtastic` method.
  def self.included(model)
    model.extend StageOne
  end

  # Sets the model's default attributes. It is called when you use
  # `#gravtastic` in your model.
  def self.configure(model, *args, &blk)
    options = args.last.is_a?(Hash) ? args.pop : {}

    model.gravatar_defaults = {
      :rating =>   'PG',
      :secure =>   true,
      :filetype => :png
    }.merge(options)

    # The method where Gravtastic get the users' email from defaults to `#email`.
    model.gravatar_source = args.first || :email
  end

  # We include Gravtastic in multiple stages. This is mainly so that if you
  # include Gravastic in a superclass (something like `ActiveRecord::Base`)
  # then it only adds the relevant methods to the classes which _actually_ use
  # it.
  module StageOne
    def gravtastic(*args, &blk)
      extend ClassMethods
      include InstanceMethods
      Gravtastic.configure(self, *args, &blk)
      self
    end

    # All these aliases deal with previous bad design decisions. Let that be a
    # lesson, name things simply, try not to follow fads and try not to break
    # backwards compatibility.
    alias_method :gravtastic!,    :gravtastic
    alias_method :has_gravatar,   :gravtastic
    alias_method :is_gravtastic,  :gravtastic
    alias_method :is_gravtastic!, :gravtastic
  end

  module ClassMethods
    attr_accessor :gravatar_source, :gravatar_defaults

    # Gravtastic abbreviates certain params so that it produces the smallest
    # possible URL. Every byte counts.
    def gravatar_abbreviations
      { :size => 's',
        :default => 'd',
        :rating => 'r'
      }
    end
  end

  module InstanceMethods

    # The raw MD5 hash of the users' email. Gravatar is particularly tricky as
    # it downcases all emails. This is really the guts of the module,
    # everything else is just convenience.
    def gravatar_id
      Digest::MD5.hexdigest(send(self.class.gravatar_source).to_s.downcase)
    end

    # Constructs the full Gravatar url.
    def gravatar_url(options={})
      options = self.class.gravatar_defaults.merge(options)
      gravatar_hostname(options.delete(:secure)) +
        gravatar_filename(options.delete(:filetype)) +
        url_params_from_hash(options)
    end

  private

    # Creates a params hash like "?foo=bar" from a hash like {'foo' => 'bar'}.
    # The values are sorted so it produces deterministic output (and can
    # therefore be tested easily).
    def url_params_from_hash(hash)
      '?' + hash.map do |key, val|
        [self.class.gravatar_abbreviations[key.to_sym] || key.to_s, val.to_s ].join('=')
      end.sort.join('&')
    end

    # Returns either Gravatar's secure hostname or not.
    def gravatar_hostname(secure)
      'http' + (secure ? 's://secure.' : '://') + 'gravatar.com/avatar/'
    end

    # Munges the ID and the filetype into one. Like "abc123.png"
    def gravatar_filename(filetype)
      "#{gravatar_id}.#{filetype}"
    end
  end

end

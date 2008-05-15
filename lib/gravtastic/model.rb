require 'digest/md5'

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
      
    end
    
    def has_gravatar?
      !!self.class.gravatar_source
    end
    
    def gravatar_id
      if value = send(self.class.gravatar_source)
        Digest::MD5.hexdigest(value.to_s)
      end
    end
    
  end
end
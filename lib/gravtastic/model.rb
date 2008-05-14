require 'digest/md5'

module Gravtastic
  module Model
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      def has_gravatar(options={:on=>:email})
        @gravatar_source = options[:on]
        self.send(:include, InstanceMethods)
      end
      
      def gravatar_source
        @gravatar_source
      end
      
    end
    
    def has_gravatar?
    end
    
    module InstanceMethods
      
      def gravatar_id
        Digest::MD5.hexdigest(send(self.class.gravatar_source).to_s)
      end
      
    end
    
  end
end
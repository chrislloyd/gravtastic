module Gravtastic
  module Model
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods

      def acts_as_gravatar_id(identifier)
        @@gravatar_id = identifier
      end
      
    end
    
  end
end

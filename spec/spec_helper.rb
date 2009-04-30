$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

def reload_gravtastic!
  Object.class_eval { remove_const :Gravtastic } if defined? Gravtastic
  require File.join(File.dirname(__FILE__),'../lib/gravtastic')
end

Spec::Runner.configure do |config|
  config.mock_with :rr
end

class Class
  def to_sym; name.to_sym end
end

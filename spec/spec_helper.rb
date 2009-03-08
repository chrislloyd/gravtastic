$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

def reload_gravtastic!
  Object.class_eval { remove_const :Gravtastic } if defined? Gravtastic
  require File.join(File.dirname(__FILE__),'../lib/gravtastic')
end

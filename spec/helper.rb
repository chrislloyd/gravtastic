$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'gravtastic'

RSpec.configure do |config|
  config.mock_with :rr
end

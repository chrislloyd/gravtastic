$:.push File.join(File.dirname(__FILE__), '..', 'lib')

Spec::Runner.configure do |config|
  config.mock_with :rr
end

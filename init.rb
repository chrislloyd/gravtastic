require_dependency 'gravtastic/model'
require_dependency 'gravtastic/helpers'

ActiveRecord::Base.send(:extend, Gravtastic::Model)
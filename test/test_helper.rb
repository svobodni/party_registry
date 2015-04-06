# -*- encoding : utf-8 -*-

# Rails
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end

class ActionController::TestCase
  include Devise::TestHelpers
end

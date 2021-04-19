# -*- encoding : utf-8 -*-

# Rails
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'aasm/minitest'
gem 'mocha'
require 'mocha/minitest'
# require 'mocha/test_unit'
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include ActionMailer::TestHelper
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

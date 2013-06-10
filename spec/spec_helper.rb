# encoding: utf-8
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_group 'EM-Logger', 'lib/em-logger'
    add_group 'Specs', 'spec'
    add_filter '.bundle'
  end
end

require 'em-logger'
require 'rspec'
require 'logger'

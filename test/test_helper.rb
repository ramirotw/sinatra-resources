require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require File.expand_path '../../app', __FILE__

DatabaseCleaner.strategy = :transaction

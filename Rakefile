# frozen_string_literal: true

require 'fileutils'

BASE_PATH = File.expand_path('.', File.dirname(__FILE__))
ARTIFACTS_PATH = ENV['ARTIFACTS_PATH'] || "#{BASE_PATH}/build"
TEST_REPORTS_PATH = ENV['TEST_REPORTS_PATH'] || "#{BASE_PATH}/reports"
BUNDLER_PATH = ENV['BUNDLER_PATH']

APP_NAME = 'swift-evolution'
WORKSPACE_PATH = nil
PROJECT_PATH = "#{BASE_PATH}/#{APP_NAME}.xcodeproj"
TEST_SCHEME = 'swift-evolution'
ARCHIVE_SCHEME = 'swift-evolution'

task default: [:help]
task :help do
  sh 'rake -T'
end

at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end

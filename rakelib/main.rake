# frozen_string_literal: true

# Xcode-rakelib - https://github.com/diogot/xcode-rakelib
# Copyright (c) 2017 Diogo Tridapalli
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Path methods
class Path
  require 'fileutils'
  # Base path
  def self.base
    Path.of '.'
  end

  # Returns the full path of a file
  # @param file of relative to the project root
  # @param fail_when_missing if true raise an exception if file don't exists
  def self.of(file, fail_when_missing: true)
    if file.nil?
      return nil
    end
    path = File.expand_path(file, File.dirname(__FILE__) + '/../')
    raise "File '#{path}' not found" if fail_when_missing && !File.exist?(path)
    path
  end
end

# Configuration
class Config
  require 'yaml'
  include Singleton

  attr_accessor :config

  def initialize
    @config = YAML.load_file Path.of 'rake-config.yml'
  end

  def [](keypath)
    path = keypath.split('.')
    @config.dig(*path)
  end

  def active(keypath)
    config = self[keypath]
    disabled?(config) ? nil : config
  end

  def disabled?(config)
    config.nil? || !config['enabled']
  end

  def app_name
    self['app_name']
  end

  def workspace_path
    Path.of self['workspace_path']
  end

  def project_path
    Path.of self['project_path']
  end
end

task default: [:help]
task :help do
  sh 'rake -T'
end

# rubocop:disable Style/SpecialGlobalVars
at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end
# rubocop:enable Style/SpecialGlobalVars

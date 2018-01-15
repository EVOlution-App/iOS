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

# -- project setup

desc 'Install/update and configure project'
task setup: %i[setup:install setup:dependencies]

namespace 'setup' do
  # -- Install

  task install: %i[bundler brew]

  desc 'Bundle install'
  task :bundler do
    config = Config.instance.active 'setup.bundler'
    next if config.nil?
    path = ENV['BUNDLER_PATH'] || config['path']
    bundler_path_option = path.nil? ? '' : "--path=#{path}"
    sh "bundle check #{bundler_path_option} || bundle install #{bundler_path_option} --jobs=4 --retry=3"
  end

  desc 'Update brew and install/update formulas'
  task :brew do
    config = Config.instance.active 'setup.brew'
    next if config.nil?
    formulas = config['formulas']
    next if formulas.nil?
    brew = Brew.new
    brew.update
    formulas.each { |formula| brew.install formula }
  end

  # Brew class
  class Brew
    def update
      Rake.sh 'brew update || brew update'
    end

    def install(formula)
      raise 'no formula' if formula.to_s.strip.empty?
      Rake.sh " ( brew list #{formula} ) && ( brew outdated #{formula} || brew upgrade #{formula} ) || ( brew install #{formula} ) "
    end
  end

  # - Dependencies

  task dependencies: %i[submodules cocoapods carthage]

  desc 'Updated submodules'
  task :submodules do
    submodules = Config.instance.active 'setup.submodules'
    next if submodules.nil?
    sh 'git submodule update --init --recursive'
  end

  # -- CocoaPods

  desc 'CocoaPods'
  task :cocoapods do
    cocoapods = Config.instance.active 'setup.cocoapods'
    next if cocoapods.nil?
    Cocoapods.new.run
  end

  desc 'Pod repo update'
  task :pod_repo_update do
    Cocoapods.new.pod_repo_update
  end

  desc 'Pod install'
  task :pod_install do
    Cocoapods.new.pod_install
  end

  # Cocoapods class
  class Cocoapods
    require 'fileutils'

    def run
      if needs_to_run_pod_install
        pod_repo_update
        pod_install
      else
        puts 'Skipping pod install because Pods seems updated'
      end
    end

    # rubocop:disable Lint/RescueException
    def needs_to_run_pod_install
      !FileUtils.identical?(Path.of('Podfile.lock'), Path.of('Pods/Manifest.lock'))
    rescue Exception => _
      true
    end
    # rubocop:enable Lint/RescueException

    def pod_repo_update
      Rake.sh 'bundle exec pod repo update --silent'
    end

    def pod_install
      Rake.sh 'bundle exec pod install'
    end
  end

  # -- Carthage

  desc 'Carthage'
  task :carthage do
    carthage = Config.instance.active 'setup.carthage'
    next if carthage.nil?
    Rake::Task['setup:carthage_install'].invoke
  end

  CARTHAGE_OPTIONS = '--platform iOS --no-use-binaries'

  task :carthage_install, [:dependency] do |_t, args|
    dependency = args[:dependency]
    sh "carthage bootstrap #{CARTHAGE_OPTIONS} #{dependency}"
  end

  desc 'Install carthage dependencies'
  task :carthage_update, [:dependency] do |_t, args|
    dependency = args[:dependency]
    sh "carthage update #{CARTHAGE_OPTIONS} #{dependency}"
  end

  task :carthage_clean, [:dependency] do |_t, args|
    has_dependency = !args[:dependency].to_s.strip.empty?
    sh 'rm -rf "~/Library/Caches/org.carthage.CarthageKit/"' unless has_dependency
    sh "rm -rf '#{Path.base}/Carthage/'" unless has_dependency
  end
end

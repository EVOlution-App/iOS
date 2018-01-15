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

# -- Project version management

namespace 'bump' do
  desc 'Bump build number'
  task :build do
    ProjectVersion.new.bump_build
  end

  desc 'Bump patch version'
  task patch: %i[has_current_version build] do
    project = ProjectVersion.new
    new_version = project.bump(option: :patch)
    project.update_version new_version
  end

  desc 'Bump minor version'
  task minor: %i[has_current_version build] do
    project = ProjectVersion.new
    new_version = project.bump(option: :minor)
    project.update_version new_version
  end

  desc 'Bump major version'
  task major: %i[has_current_version build] do
    project = ProjectVersion.new
    new_version = project.bump(option: :major)
    project.update_version new_version
  end

  task :has_current_version do
    sh ProjectVersion.new.current_version_command
  end

  task :set_version, [:version] do |_t, args|
    ProjectVersion.new.update_version args[:version]
  end

  # Bump versions helper
  class ProjectVersion
    require 'fileutils'
    def initialize
      @project_path = File.dirname(Config.instance.project_path)
    end

    def update_version(version)
      Rake.sh "cd #{@project_path} && agvtool new-marketing-version #{version.to_s.strip}"
    end

    def bump_build
      Rake.sh "cd #{@project_path} && agvtool next-version -all"
    end

    def bump(version: current_version, option: '')
      version = version.split('.').map(&:to_i)
      case option
      when :patch
        version[2] = increase_number version[2]
      when :minor
        version.delete_at(2)
        version[1] = increase_number version[1]
      when :major
        version.delete_at(2)
        version[1] = 0
        version[0] = increase_number version[0]
      end
      version.join('.')
    end

    def increase_number(option)
      option.nil? ? 1 : option + 1
    end

    def full_version
      "#{current_version}-#{current_build}"
    end

    def current_version
      `#{current_version_command}`.strip!
    end

    def current_build
      `#{current_build_command}`.strip!
    end

    def current_version_command
      "cd #{@project_path} && agvtool mvers -terse1"
    end

    def current_build_command
      "cd #{@project_path} && agvtool vers -terse"
    end
  end
end

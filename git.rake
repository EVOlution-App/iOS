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

begin
  require 'git'
rescue LoadError
  puts 'git not installed yet!'
end

namespace 'git' do
  desc 'Add tag with current version'
  task :add_tag do
    version = ProjectVersion.new.full_version
    puts "Add tag #{version}"
    git_working_directory.add_tag(version)
  end

  desc 'Push current branch and tags'
  task :push do
    puts 'git push'
    g = git_working_directory
    branch = g.current_branch
    remote = 'origin'
    git_working_directory.push(remote, branch, tags: true)
  end

  def git_working_directory
    Git.open(Path.base)
  end
end

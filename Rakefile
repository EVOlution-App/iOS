require 'fileutils'

BASE_PATH = File.expand_path('.', File.dirname(__FILE__))

task :default => [ :help ]
task :help do
  sh 'rake -T'
end

at_exit do
  puts '           ¯\_(ツ)_/¯' unless $!.nil? || $!.is_a?(SystemExit) && $!.success?
end

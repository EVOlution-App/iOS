# frozen_string_literal: true

# # -- project setup

desc 'Install/update and configure project'
task setup: %i[setup_dependencies configure]

task setup_dependencies: %i[install_dependencies] do
  if BUNDLER_PATH.nil?
    sh 'bundle install'
  else
    sh "bundle check --path=#{BUNDLER_PATH} || bundle install --path=#{BUNDLER_PATH} --jobs=4 --retry=3"
  end
end

task configure: %i[carthage_install clean_artifacts]

task :install_dependencies do
  brew_update
  brew_install 'swiftlint'
  brew_install 'carthage'
end

# -- carthage

CARTHAGE_OPTIONS = '--platform iOS --no-use-binaries'

desc 'Install dependencies in Carthage'
task :carthage_install, [:dependency] do |_t, args|
  dependency = args[:dependency]
  sh "carthage bootstrap #{CARTHAGE_OPTIONS} #{dependency}"
end

task :carthage_update, [:dependency] do |_t, args|
  dependency = args[:dependency]
  sh "carthage update #{CARTHAGE_OPTIONS} #{dependency}"
end

task :carthage_clean, [:dependency] do |_t, args|
  has_dependency = !args[:dependency].to_s.strip.empty?
  sh 'rm -rf "~/Library/Caches/org.carthage.CarthageKit/"' unless has_dependency
  sh "rm -rf '#{BASE_PATH}/Carthage/'" unless has_dependency
end

# -- brew

def brew_update
  sh 'brew update || brew update'
end

def brew_install(formula)
  raise 'no formula' if formula.to_s.strip.empty?
  sh " ( brew list #{formula} ) && ( brew outdated #{formula} || brew upgrade #{formula} ) || ( brew install #{formula} ) "
end

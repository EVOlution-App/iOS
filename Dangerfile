
def warning_important_file_changed(file)
  warn "Modified #{file}?" if git.modified_files.include?(file)
end

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn 'PR is classed as Work in Progress' if (github.pr_title + github.pr_body).include? "[WIP]"

# Warn when there is a big PR
warn 'Big PR' if git.lines_of_code > 1000

warning_important_file_changed '.gitignore'
# warning_important_file_changed '.travis.yml'
# warning_important_file_changed 'circle.yml'
warning_important_file_changed 'Rakefile'
warning_important_file_changed 'Gemfile'
warning_important_file_changed 'Gemfile.lock'

fail 'Please add labels to this PR' if github.pr_labels.empty?

if github.pr_body.length < 5
  fail 'Please provide a summary in the Pull Request description'
end

# Xcode
build_file = File.expand_path 'result.json'
system "rake generate_xcode_summary[#{build_file}]"
xcode_summary.report build_file

slather.configure('swift-evolution.xcodeproj', 'swift-evolution')
slather.notify_if_coverage_is_less_than(minimum_coverage: 80, notify_level: :warning)
slather.notify_if_modified_file_is_less_than(minimum_coverage: 50, notify_level: :warning)
slather.show_modified_files_coverage

# RuboCop
rubocop.lint

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "update fixtures"
task :update_fixtures do
  sh "curl -o spec/fixtures/trending/index https://github.com/trending"
  sh "curl -o spec/fixtures/trending/ruby https://github.com/trending/ruby"
  sh "curl -o spec/fixtures/trending/alloy https://github.com/trending/alloy"
  sh "curl -o spec/fixtures/trending/ruby?since=weekly https://github.com/trending/ruby?since=weekly"

  sh "curl -o spec/fixtures/trending?since= https://github.com/trending?since="
  sh "curl -o spec/fixtures/trending?since=daily https://github.com/trending?since=daily"
  sh "curl -o spec/fixtures/trending?since=weekly https://github.com/trending?since=weekly"
  sh "curl -o spec/fixtures/trending?since=monthly https://github.com/trending?since=monthly"
end

desc "check that scraping works against the live GitHub trending page"
task :smoke do
  require_relative "lib/git_trend"

  projects = GitTrend.get
  errors = []
  errors << "no projects" if projects.empty?
  errors << "invalid names" unless projects.all? { |p| p.name.match?(%r{\A[\w.-]+/[\w.-]+\z}) }
  errors << "no descriptions" if projects.none? { |p| !p.description.empty? }
  errors << "no languages" if projects.none? { |p| !p.lang.empty? }
  errors << "no all star counts" unless projects.all? { |p| p.all_star_count.positive? }
  errors << "no fork counts" if projects.none? { |p| p.fork_count.positive? }
  errors << "no star counts" if projects.none? { |p| p.star_count.positive? }
  errors << "no selectable languages" if GitTrend.languages.empty?

  abort "Smoke test failed: #{errors.join(', ')}" unless errors.empty?

  puts "Smoke test passed: #{projects.size} projects"
end

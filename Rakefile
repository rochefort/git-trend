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

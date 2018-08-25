# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_trend/version"

def install_message
  s = ""
  s << "\xf0\x9f\x8d\xba  " if or_over_mac_os_lion?
  s << "Thanks for installing!"
end

def or_over_mac_os_lion?
  return false unless RUBY_PLATFORM =~ /darwin/

  macos_full_version = `/usr/bin/sw_vers -productVersion`.chomp
  macos_version = macos_full_version[/10\.\d+/]
  macos_version >= "10.7" # 10.7 is lion
end

Gem::Specification.new do |spec|
  spec.name          = "git-trend"
  spec.version       = GitTrend::VERSION
  spec.authors       = ["rochefort"]
  spec.email         = ["terasawan@gmail.com"]
  spec.summary       = "CLI-Based tool that show Trending repository on github"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/rochefort/git-trend"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = install_message

  spec.add_dependency "addressable", "~> 2.5.1"
  spec.add_dependency "mb_string",   "~> 0.1.8"
  spec.add_dependency "mechanize",   "~> 2.7.5"
  spec.add_dependency "thor",        ">= 0.19.4", "< 0.21.0"
  spec.add_dependency "unicode-display_width", ">= 1.3", "< 1.5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake",    "~> 12.3.1"

  spec.add_development_dependency "rspec",     "~> 3.8.0"
  spec.add_development_dependency "simplecov", "~> 0.12.0"
  spec.add_development_dependency "safe_yaml", "~> 1.0.4" # for Ruby2.2.0
  spec.add_development_dependency "webmock",   "~> 3.4.2"

  spec.add_development_dependency "coveralls", "~> 0.8.19"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0.8"
end

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_trend/version"

def install_message
  s = ""
  s << "\xf0\x9f\x8d\xba  "
  s << "Thanks for installing!"
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
  spec.required_ruby_version = ">= 2.5.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = install_message

  spec.add_dependency "addressable", "~> 2.8"
  spec.add_dependency "mb_string"
  spec.add_dependency "mechanize",   ">= 2.7.5", "< 2.9.0"
  spec.add_dependency "thor",        ">= 0.20.0", "< 1.3.0"
  spec.add_dependency "unicode-display_width"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake",    "~> 13.0.0"

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rails"

  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec",     "~> 3.11.0"
  spec.add_development_dependency "simplecov", "~>0.16.1"
  spec.add_development_dependency "webmock",   "~> 3.16.0"

  spec.add_development_dependency "coveralls", "~> 0.8.23"
end

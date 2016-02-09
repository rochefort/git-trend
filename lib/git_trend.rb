require 'mb_string'

require 'git_trend/cli'
require 'git_trend/project'
require 'git_trend/scraper'
require 'git_trend/version'

module GitTrend
  class ScrapeException < StandardError; end
end

require 'git_trend/ext'

module GitTrend
  autoload :CLI,       'git_trend/cli'
  autoload :Project,   'git_trend/project'
  autoload :Rendering, 'git_trend/rendering'
  autoload :Scraper,   'git_trend/scraper'
  autoload :VERSION,   'git_trend/version'
end

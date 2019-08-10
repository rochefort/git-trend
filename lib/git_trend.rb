require "mb_string"

require "git_trend/cli"
require "git_trend/formatter"
require "git_trend/formatters/text_formatter"
require "git_trend/formatters/json_formatter"
require "git_trend/project"
require "git_trend/scraper"
require "git_trend/version"

module GitTrend
  # GitTrend.get
  # GitTrend.get('ruby')
  # GitTrend.get(:ruby)
  #
  # GitTrend.get(since: :weekly)
  # GitTrend.get(since: :week)
  # GitTrend.get(since: :w)
  #
  # GitTrend.get('ruby', 'weekly')
  # GitTrend.get(:ruby, :weekly)
  # GitTrend.get(language: :ruby, since: :weekly)
  def self.get(*opts)
    if opts[0].instance_of?(Hash)
      hash = opts[0]
      language = hash.key?(:language) ? hash[:language] : nil
      since = hash.key?(:since) ? hash[:since] : nil
      Scraper.new.get(language, since)
    else
      Scraper.new.get(*opts)
    end
  end

  def self.languages
    Scraper.new.languages
  end
end

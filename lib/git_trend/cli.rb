require 'thor'

module GitTrend
  class CLI < Thor
    map '-v'              => :version,
        '--version'       => :version

    default_command :list

    desc :version, 'show version'
    def version
      say "git-trend version: #{VERSION}", :green
    end

    desc :list, '[List] Trending repository on github'
    option :list, aliases:'-l', required: false
    def list
      scraper = Scraper.new
      scraper.get(options[:list])
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message
    end

    desc :all_languages, 'Show selectable languages'
    def all_languages
      scraper = Scraper.new
      scraper.list_all_languages
    end
  end
end

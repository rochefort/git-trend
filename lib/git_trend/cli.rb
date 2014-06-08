require 'thor'

module GitTrend
  class CLI < Thor
    map '-v'              => :version,
        '--version'       => :version,
        '-l'              => :show,
        '--list'          => :show,
        '--all-languages' => :all_languages

    default_command :show

    desc :version, 'show version'
    def version
      say "git-trend version: #{VERSION}", :green
    end

    desc :show, 'show Trending repository on github'
    def show(language=nil)
      scraper = Scraper.new
      scraper.get(language)
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message
    end

    desc :all_languages, 'show selectable languages'
    def all_languages
      scraper = Scraper.new
      scraper.list_all_languages
    end
  end
end

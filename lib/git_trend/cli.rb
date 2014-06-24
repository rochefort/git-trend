require 'thor'

module GitTrend
  class CLI < Thor
    include GitTrend::Rendering

    map '-v'              => :version,
        '--version'       => :version

    default_command :list

    desc :version, 'show version'
    def version
      say "git-trend version: #{VERSION}", :green
    end

    desc :list, 'List Trending repository on github (default command)'
    option :language,    aliases:'-l', required: false
    option :since,       aliases:'-s', required: false
    option :description, aliases:'-d', required: false
    def list
      scraper = Scraper.new
      projects = scraper.get(options[:language], options[:since])
      render(projects, !!options[:description])
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message
    end

    desc :all_languages, 'Show selectable languages'
    def all_languages
      scraper = Scraper.new
      languages = scraper.list_all_languages
      render_all_languages(languages)
    end
  end
end

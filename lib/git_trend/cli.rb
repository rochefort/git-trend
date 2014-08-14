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

    desc :list, "\033[32m(DEFAULT COMMAND)\e[0m List Trending repository on github [-l, -s, -d]"
    option :language,    aliases: '-l', required: false, desc: 'Specify a language'
    option :since,       aliases: '-s', required: false, desc: 'Enable: [daily, weekly, monthly]'
    option :description, aliases: '-d', required: false, type: :boolean, desc: 'Dislpay descriptions'
    option :help,        aliases: '-h', required: false, type: :boolean
    def list
      help(:list) and return if  options[:help]
      scraper = Scraper.new
      projects = scraper.get(options[:language], options[:since])
      render(projects, !!options[:description])
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message
    end

    desc :languages, 'Show selectable languages'
    def languages
      scraper = Scraper.new
      languages = scraper.list_languages
      render_languages(languages)
    end
  end
end

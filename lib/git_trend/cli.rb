require "thor"

# rubocop:disable Layout/LineLength, Metrics/AbcSize
module GitTrend
  class CLI < Thor
    map "-v"              => :version,
        "--version"       => :version

    default_command :list
    class_option :verbose, type: :boolean

    class << self
      def exit_on_failure?
        true
      end
    end

    desc :version, "show version"
    def version
      say "git-trend version: #{VERSION}", :green
    end

    desc :list, "\033[32m(DEFAULT COMMAND)\e[0m List Trending repository on github [-l, -s, -d]"
    option :language,    aliases: "-l", required: false, desc: "Specify a language"
    option :since,       aliases: "-s", required: false, desc: "Enable: [d, day, daily, w, week, weekly, m, month, monthly]"
    option :description, aliases: "-d", required: false, default: true, type: :boolean, desc: "\033[32m(DEFAULT OPTION)\e[0m Dislpay descriptions"
    option :format,      aliases: "-f", required: false, default: "text", desc: "Choose a formatter as text or json. Enable: [t, text, j, json]"
    option :number,      aliases: "-n", required: false, type: :numeric, desc: "Number of lines"
    option :help,        aliases: "-h", required: false, type: :boolean
    def list
      help(:list) && return if options[:help]

      scraper = Scraper.new
      projects = scraper.get(options[:language], options[:since], options[:number])
      formatter = Formatter.new(options[:format])
      formatter.print(projects, enable_description: !!options[:description])
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message unless e.instance_of?(e.message) # エラー内容がクラス名の場合は表示しない

      puts exception.backtrace if options[:verbose]
    end

    desc :languages, "Show selectable languages"
    option :format,      aliases: "-f", required: false, default: "text", desc: "Choose a formatter as text or json. Enable: [t, text, j, json]"
    def languages
      scraper = Scraper.new
      languages = scraper.languages
      formatter = Formatter.new(options[:format])
      formatter.print_languages(languages)
    end
  end
end
# rubocop:enable Layout/LineLength, Metrics/AbcSize

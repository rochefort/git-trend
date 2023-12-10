require "json"

module GitTrend::Formatters
  class JsonFormatter
    def print(projects, options) # rubocop:disable Lint/UnusedMethodArgument
      puts projects.map(&:to_h).to_json
    end

    def print_languages(languages)
      puts languages.to_json
    end
  end
end

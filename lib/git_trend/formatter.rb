module GitTrend
  class Formatter
    def initialize(key)
      @formatter = formatter_class(key).new
    end

    def print(projects, options = nil)
      @formatter.print(projects, options)
    end

    def print_languages(languages)
      @formatter.print_languages(languages)
    end

    private
      def formatter_class(key)
        case key
        when "j", "json" then Formatters::JsonFormatter
        else Formatters::TextFormatter
        end
      end
  end
end

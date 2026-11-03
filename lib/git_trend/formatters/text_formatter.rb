require "io/console"

module GitTrend::Formatters
  class TextFormatter
    HEADER_COLUMNS = %w[no. name lang star description].freeze
    DEFAULT_COLUMNS_SIZES = [3, 40, 10, 6, 20].freeze
    DEFAULT_TERMINAL_WIDTH = 80

    def print(projects, options)
      if projects.empty?
        render_zero
        return
      end
      @enable_description = options[:enable_description]
      rule_columns_sizes(projects)
      render_header
      render_body(projects)
      render_footer
    end

    def print_languages(languages)
      puts languages
      puts
      puts "#{languages.size} languages"
      puts "you can get only selected language list with '-l' option."
      puts "if languages is unknown, you can specify 'unknown'."
      puts
    end

    private

      def render_zero
        puts "It looks like we don’t have any trending repositories."
        puts
      end

      def rule_columns_sizes(projects)
        @columns_sizes = DEFAULT_COLUMNS_SIZES.dup
        rule_max_column_size(projects, :name)
        rule_max_column_size(projects, :lang)
        rule_max_description_size if @enable_description
        @columns_sizes.pop unless @enable_description
      end

      def rule_max_description_size
        description_width = detect_terminal_width - @columns_sizes[0..-2].sum - (@columns_sizes.size - 1)
        if description_width >= DEFAULT_COLUMNS_SIZES.last
          @columns_sizes[-1] = description_width
        else
          @enable_description = false
        end
      end

      def rule_max_column_size(projects, attr)
        index = HEADER_COLUMNS.index(attr.to_s)
        max_size = max_size_of(projects, attr)
        @columns_sizes[index] = max_size if max_size > @columns_sizes[index]
      end

      def max_size_of(projects, attr)
        projects.max_by { |project| project.send(attr).size }.send(attr).size
      end

      def render_header
        header = HEADER_COLUMNS.map(&:capitalize)
        header.pop unless @enable_description
        f = @columns_sizes
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s"
        fmt << " %-#{f[4]}s" if @enable_description

        puts (fmt % header).rstrip
        puts fmt % @columns_sizes.map { |column| "-" * column }
      end

      # rubocop:disable-next Metrics/AbcSize
      def render_body(projects)
        f = @columns_sizes
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s"
        description_fmt = ""
        projects.each_with_index do |project, i|
          data = [i + 1, [project.name, project.lang, project.star_count.to_s]].flatten
          if @enable_description
            description = project.description.mb_truncate(f.last)
            data << description
            mb_char_size = description.display_width - description.size
            description_fmt = " %-#{f.last - mb_char_size}s"
          end
          result = "#{fmt}#{description_fmt}" % data
          puts result.rstrip
        end
      end

      def render_footer
        puts
      end

      def detect_terminal_width
        return ENV["COLUMNS"].to_i if ENV["COLUMNS"]&.match?(/\A\d+\z/)

        IO.console&.winsize&.last || DEFAULT_TERMINAL_WIDTH
      rescue SystemCallError
        DEFAULT_TERMINAL_WIDTH
      end
  end
end

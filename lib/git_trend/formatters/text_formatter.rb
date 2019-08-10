module GitTrend::Formatters
  class TextFormatter
    HEADER_COLUMNS = %w(no. name lang star description)
    DEFAULT_COLUMNS_SIZES = [3, 40, 10, 6, 20]

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
      puts "if languages is unknown, you can specify 'unkown'."
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
        terminal_width, _terminal_height = detect_terminal_size
        description_width = terminal_width - @columns_sizes[0..-2].inject(&:+) - (@columns_sizes.size - 1)
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

        puts fmt % header
        puts fmt % @columns_sizes.map { |column| "-" * column }
      end

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
          puts result
        end
      end

      def render_footer
        puts
      end

      # https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
      def detect_terminal_size
        if (ENV["COLUMNS"] =~ /^\d+$/) && (ENV["LINES"] =~ /^\d+$/)
          [ENV["COLUMNS"].to_i, ENV["LINES"].to_i]
        elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV["TERM"])) && command_exists?("tput")
          [`tput cols`.to_i, `tput lines`.to_i]
        elsif STDIN.tty? && command_exists?("stty")
          `stty size`.scan(/\d+/).map(&:to_i).reverse
        end
      rescue
        nil
      end

      def command_exists?(command)
        ENV["PATH"].split(File::PATH_SEPARATOR).any? { |d| File.exist? File.join(d, command) }
      end
  end
end

module GitTrend
  module Rendering
    def self.included(base)
      base.extend(self)
    end

    # header columns:
    # 'No.', 'Name', 'Lang', 'Star', 'Fork', ['Description']
    DEFAULT_RULED_LINE_SIZE = [3, 40, 10, 6]
    DESCRIPTION_MIN_SIZE = 20

    def render(projects, describable = false)
      @describable = describable
      ruled_line_size(projects)
      render_to_header
      render_to_body(projects)
    end

    def render_languages(languages)
      puts languages
      puts
      puts "#{languages.size} languages"
      puts "you can get only selected language list with '-l' option."
      puts "if languages is unknown, you can specify 'unkown'."
      puts
    end

    private

    def max_size_of(projects, attr)
      projects.max_by { |project| project.send(attr).size }.send(attr).size
    end

    def ruled_line_size(projects)
      @ruled_line_size = DEFAULT_RULED_LINE_SIZE.dup
      max_name_size = max_size_of(projects, :name)
      if max_name_size > @ruled_line_size[1]
        @ruled_line_size[1] = max_name_size
      end

      max_lang_size = max_size_of(projects, :lang)
      if max_lang_size > @ruled_line_size[2]
        @ruled_line_size[2] = max_lang_size
      end

      # setting description size
      if @describable
        terminal_width, _terminal_height = detect_terminal_size
        description_width = terminal_width - @ruled_line_size.inject(&:+) - @ruled_line_size.size
        if description_width >= DESCRIPTION_MIN_SIZE
          @ruled_line_size << description_width
        else
          @describable = false
        end
      end
    end

    def render_to_header
      f = @ruled_line_size
      if @describable
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s %-#{f[4]}s"
      else
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s"
      end
      header = ['No.', 'Name', 'Lang', 'Star']
      header << 'Description' if @describable
      puts fmt % header
      puts fmt % @ruled_line_size.map { |field| '-'*field }
    end

    def render_to_body(projects)
      f = @ruled_line_size
      fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s"
      projects.each_with_index do |project, i|
        result = fmt % [i + 1, project.to_a].flatten
        result << ' ' + project.description.mb_slice(f.last).mb_ljust(f.last) if @describable
        puts result
      end
    end

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |d| File.exist? File.join(d, command) }
    end

    # https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
    def detect_terminal_size
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exists?('tput')
        [`tput cols`.to_i, `tput lines`.to_i]
      elsif STDIN.tty? && command_exists?('stty')
        `stty size`.scan(/\d+/).map {  |s| s.to_i }.reverse
      else
        nil
      end
    rescue
      nil
    end
  end
end

module GitTrend
  module Rendering
    # 'No.', 'Name', 'Lang', 'Star', 'Fork'
    DEFAULT_RULED_LINE_SIZE = [3, 40, 10, 6, 5]

    def self.included(base)
      base.extend(self)
    end

    def render(projects)
      set_ruled_line_size(projects)
      render_to_header
      render_to_body(projects)
    end

    def render_all_languages(languages)
      puts languages
      puts
      puts "#{languages.size} languages"
      puts "you can get only selected language list with '-l' option"
    end

    private
      def max_size_of(projects, attr)
        projects.max_by { |project| project.send(attr).size }.send(attr).size
      end

      def set_ruled_line_size(projects)
        max_name_size = max_size_of(projects, :name)
        if max_name_size > DEFAULT_RULED_LINE_SIZE[1]
          DEFAULT_RULED_LINE_SIZE[1] = max_name_size
        end

        max_lang_size = max_size_of(projects, :lang)
        if max_lang_size > DEFAULT_RULED_LINE_SIZE[2]
          DEFAULT_RULED_LINE_SIZE[2] = max_lang_size
        end
      end

      def render_to_header
        f=DEFAULT_RULED_LINE_SIZE.dup
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s %#{f[4]}s"
        puts fmt % ['No.', 'Name', 'Lang', 'Star', 'Fork']
        puts fmt % f.map{ |_f| '-'*_f }
      end

      def render_to_body(projects)
        f=DEFAULT_RULED_LINE_SIZE.dup
        fmt = "%#{f[0]}s %-#{f[1]}s %-#{f[2]}s %#{f[3]}s %#{f[4]}s"
        projects.each_with_index { |project, i| puts fmt % [i+1, project.to_a].flatten }
      end
  end
end

require "unicode/display_width"

module GitTrend
  module DisplayText
    ELLIPSIS = "...".freeze

    module_function

    def width(str)
      Unicode::DisplayWidth.of(str)
    end

    def truncate(str, truncate_at)
      return str if width(str) <= truncate_at
      return ELLIPSIS if truncate_at <= ELLIPSIS.length

      max_width = truncate_at - ELLIPSIS.length
      result = +""
      current_width = 0
      str.each_grapheme_cluster do |char|
        char_width = width(char)
        break if current_width + char_width > max_width

        result << char
        current_width += char_width
      end

      "#{result}#{ELLIPSIS}"
    end
  end
end

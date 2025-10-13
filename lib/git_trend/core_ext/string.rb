class String
  def mb_truncate(truncate_at)
    return self if display_width <= truncate_at

    ellipsis = "..."
    return ellipsis if truncate_at <= ellipsis.length

    max_width = truncate_at - ellipsis.length
    result = ""
    current_width = 0
    each_char do |char|
      char_width = char.bytesize == 1 ? 1 : 2
      break if current_width + char_width > max_width

      result += char
      current_width += char_width
    end

    "#{result}#{ellipsis}"
  rescue
    self
  end

  def display_width
    each_char.sum { |char| char.bytesize == 1 ? 1 : 2 }
  end
end

class String
  def mb_width
    each_char.inject(0) { |sum, c| sum += c.ascii_only? ? 1 : 2 }
  end

  def mb_slice(width)
    return '' if empty?

    max_size = width - 3 # 3 is '...' size.
    extraction_size = 0
    extraction = ''
    each_char do |c|
      char_size = c.ascii_only? ? 1 : 2
      if extraction_size + char_size > max_size
        extraction << '...'
        break
      end
      extraction_size += char_size
      extraction << c
    end
    extraction
  end

  def mb_ljust(width, padding = ' ')
    padding_size = [0, width - mb_width].max
    self + padding * padding_size
  end
end

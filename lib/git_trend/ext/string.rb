require 'unicode/display_width'

class String
  def mb_slice(width)
    return '' if empty?

    max_size = width - 3 # 3 is '...' size.
    extraction_size = 0
    extraction = ''
    each_char do |c|
      char_size = c.display_width
      if extraction_size + char_size > max_size
        extraction << '...'
        break
      end
      extraction_size += char_size
      extraction << c
    end
    extraction
  end
end

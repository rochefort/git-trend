module Git::Trend
  class Project
    attr_accessor :name, :lang, :description, :star_count, :fork_count

    def to_a
      [@name, @star_count.to_s, @fork_count.to_s]
    end
  end
end

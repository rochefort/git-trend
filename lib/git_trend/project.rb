module GitTrend
  class Project
    attr_accessor :name, :description, :lang, :all_star_count, :fork_count, :star_count

    def initialize(name: "", description: "", lang: "", all_star_count: 0, fork_count: 0, star_count: 0)
      self.name = name
      self.description = description
      self.lang = lang
      self.all_star_count = all_star_count
      self.fork_count = fork_count
      self.star_count = star_count
    end

    def to_a
      [@name, @lang, @star_count.to_s]
    end
  end
end

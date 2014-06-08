require 'mechanize'
# require 'pp'

module Git::Trend
  class Scraper
    include Git::Trend::Rendering
    BASE_URL = 'https://github.com/trending'

    def initialize
      @agent = Mechanize.new
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      if proxy
        @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password)
      end
    end

    def get
      projects = []
      page = @agent.get(BASE_URL)

      page.search('.leaderboard-list-content').each do |content|
        project = Project.new
        project.lang        = content.search('.repo-leaderboard-title .title-meta').text
        project.name        = content.search('.repo-leaderboard-title a').text
        project.description = content.search('.repo-leaderboard-description').text

        project.star_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-star'))
        project.fork_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-git-branch'))

        # pp project
        projects << project
      end
      Scraper.render(projects)
    end

    private
      def meta_count(elm)
        if elm.empty?
          0
        else
          # p elm[0].parent.text
          elm[0].parent.text.to_i
        end
        # elm.empty? ? 0 : elm[0].parent.text.to_i
      end
  end
end

require 'mechanize'

module GitTrend
  class Scraper
    include GitTrend::Rendering
    BASE_URL = 'https://github.com/trending'

    def initialize
      @agent = Mechanize.new
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      if proxy
        @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password)
      end
    end

    def get(language)
      projects = []
      page = @agent.get(generate_get_url(language))

      page.search('.leaderboard-list-content').each do |content|
        project = Project.new
        project.lang        = content.search('.repo-leaderboard-title .title-meta').text
        project.name        = content.search('.repo-leaderboard-title a').text
        project.description = content.search('.repo-leaderboard-description').text

        project.star_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-star'))
        project.fork_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-git-branch'))

        projects << project
      end
      Scraper.render(projects)
    end

    def list_all_languages
      languages = []
      page = @agent.get(BASE_URL)
      page.search('div.select-menu-item a').each do |content|
        href = content.attributes['href'].value
        # objective-c++ =>
        language = href.match(/github.com\/trending\?l=(.+)/).to_a[1]
        languages << CGI.unescape(language) if language
      end
      Scraper.render_all_languages(languages)
    end

    private
      def generate_get_url(language)
        if language
          "#{BASE_URL}?l=#{CGI.escape(language)}"
        else
          BASE_URL
        end
      end

      def meta_count(elm)
        elm.empty? ? 0 : elm[0].parent.text.to_i
      end
  end
end

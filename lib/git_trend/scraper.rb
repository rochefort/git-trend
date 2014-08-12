require 'mechanize'
require 'addressable/uri'

module GitTrend
  class Scraper
    BASE_HOST = 'https://github.com'
    BASE_URL = "#{BASE_HOST}/trending"

    def initialize
      @agent = Mechanize.new
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password) if proxy
    end

    def get(language = nil, since = nil)
      projects = []
      page = @agent.get(generate_url_for_get(language, since))

      page.search('.leaderboard-list-content').each do |content|
        project = Project.new
        project.lang        = content.search('.repo-leaderboard-title .title-meta').text
        project.name        = content.search('.repo-leaderboard-title a').text
        project.description = content.search('.repo-leaderboard-description').text

        project.star_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-star'))
        project.fork_count  = meta_count(content.search('.repo-leaderboard-meta .repo-leaderboard-meta-item .octicon-git-branch'))

        projects << project
      end
      projects
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
      languages
    end

    private

    def generate_url_for_get(language, since)
      uri = Addressable::URI.parse(BASE_URL)
      if language || since
        uri.query_values = { l: language, since: since }.delete_if { |_k, v| v.nil? }
      end
      uri.to_s
    end

    def meta_count(elm)
      elm.empty? ? 0 : elm[0].parent.text.strip.gsub(',', '').to_i
    end
  end
end

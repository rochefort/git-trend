require "mechanize"
require "addressable/uri"

module GitTrend
  class Scraper
    BASE_HOST = "https://github.com"
    BASE_URL = "#{BASE_HOST}/trending"

    def initialize
      @agent = Mechanize.new
      @agent.user_agent = "git-trend #{VERSION}"
      proxy = URI.parse(ENV["http_proxy"]) if ENV["http_proxy"]
      @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password) if proxy
    end

    def get(language = nil, since = nil, number = nil)
      page = @agent.get(generate_url(language, since))
      projects = generate_project(page)
      fail ScrapeException if projects.empty?
      number ? projects[0...number] : projects
    end

    def languages
      page = @agent.get(BASE_URL)
      page.search(".language-filter-list + .select-menu span.select-menu-item-text").inject([]) do |languages, content|
        languages << content.text if content.text
      end
    end

    private

      def generate_url(language, since)
        url = BASE_URL.dup
        url << "/#{language}" if language
        uri = Addressable::URI.parse(url)
        since = convert_url_param_since(since)
        if since
          uri.query_values = { since: since }.delete_if { |_k, v| v.nil? }
        end
        uri.to_s
      end

      def convert_url_param_since(since)
        return unless since
        case since.to_sym
        when :d, :day,   :daily   then "daily"
        when :w, :week,  :weekly  then "weekly"
        when :m, :month, :monthly then "monthly"
        else ""
        end
      end

      def generate_project(page)
        content = page.search(".repo-list li").map do |content|
          Project.new(
            name: content.search("h3 a").attr("href").to_s.sub(/\A\//, ""),
            description: content.search(".py-1").text.strip,
            lang: content.search('span[itemprop="programmingLanguage"]').text.strip,
            all_star_count: content.search('a[aria-label="Stargazers"]').text.strip.delete(",").to_i,
            fork_count: content.search('a[aria-label="Forks"]').text.strip.delete(",").to_i,
            star_count: content.search("span.float-right").text.strip.match(/(\d+)? stars/).to_a[1].to_i
          )
        end
      end
  end
end

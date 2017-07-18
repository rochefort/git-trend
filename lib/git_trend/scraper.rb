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
      page.search(".col-md-3 .select-menu-list span.select-menu-item-text").inject([]) do |languages, content|
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
        page.search(".repo-list li").map do |content|
          all_star_count = comma_to_i(content.search('svg[aria-label="star"]')[0].parent.text.strip)
          fork_elm = content.search('svg[aria-label="fork"]')[0]
          fork_count = fork_elm ? comma_to_i(fork_elm.parent.text.strip) : 0
          star_count = comma_to_i(content.search("span.float-sm-right").text.strip.match(/(.+)? stars/).to_a[1])
          Project.new(
            name: content.search("h3 a").attr("href").to_s.sub(/\A\//, ""),
            description: content.search(".py-1").text.strip,
            lang: content.search('span[itemprop="programmingLanguage"]').text.strip,
            all_star_count: all_star_count,
            fork_count: fork_count,
            star_count: star_count
          )
        end
      end

      def comma_to_i(obj)
        obj.to_s.delete(",").to_i
      end
  end
end

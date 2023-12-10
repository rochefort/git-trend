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
      number ? projects[0...number] : projects
    end

    def languages
      page = @agent.get(BASE_URL)
      page.search("#select-menu-language .select-menu-list .select-menu-item-text").inject([]) do |languages, content|
        language = content.text.strip
        languages << language if language
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
        page.search(".Box-row").map do |content|
          icon_area = content.search(".f6.color-fg-muted.mt-2")
          Project.new(
            name: content.search("h2 a").attr("href").to_s.sub(/\A\//, ""),
            description: content.search(".col-9.color-fg-muted.my-1.pr-4").text.strip,
            lang: content.search('span[itemprop="programmingLanguage"]').text.strip,
            all_star_count: comma_to_i(icon_area.search("a:has(svg.octicon-star)").text.strip),
            fork_count: comma_to_i(icon_area.search("a:has(svg.octicon-repo-forked)").text.strip),
            star_count: comma_to_i(icon_area.search(".float-sm-right").text)
          )
        end
      end

      def comma_to_i(obj)
        obj.to_s.delete(",").to_i
      end
  end
end

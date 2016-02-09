# -*- coding: utf-8 -*-
require 'mechanize'
require 'addressable/uri'

module GitTrend
  class Scraper
    BASE_HOST = 'https://github.com'
    BASE_URL = "#{BASE_HOST}/trending"

    def initialize
      @agent = Mechanize.new
      @agent.user_agent = "git-trend #{VERSION}"
      proxy = URI.parse(ENV['http_proxy']) if ENV['http_proxy']
      @agent.set_proxy(proxy.host, proxy.port, proxy.user, proxy.password) if proxy
    end

    def get(language = nil, since = nil, number = nil)
      page = @agent.get(generate_url_for_get(language, since))
      projects = generate_project(page)
      fail ScrapeException if projects.empty?
      number ? projects[0...number] : projects
    end

    def languages
      page = @agent.get(BASE_URL)
      page.search('.language-filter-list + .select-menu span.select-menu-item-text').inject([]) do |languages, content|
        languages << content.text if content.text
      end
    end

    private

    def generate_url_for_get(language, since)
      uri = Addressable::URI.parse(BASE_URL)
      if language || since
        uri.query_values = { l: language, since: since }.delete_if { |_k, v| v.nil? }
      end
      uri.to_s
    end

    # Pattern 1: lang + stars
    #  Ruby • 24 stars today • Built by
    # Pattern 2: only stars
    #  85 stars today • Built by
    # Pattern 3: only lang
    #  ASP • Built by
    def extract_lang_and_star_from_meta(text)
      meta_data = text.split('•').map { |x| x.delete("\n").strip }
      meta_data.pop # remove "Build by"
      if meta_data.size == 2
        [meta_data[0], meta_data[1].delete(',').to_i]
      else
        if meta_data[0].include?('stars')
          ['', meta_data[0].delete(',').to_i]
        else
          [meta_data[0], 0]
        end
      end
    end

    def generate_project(page)
      page.search('.repo-list-item').map do |content|
        project = Project.new
        meta_data = content.search('.repo-list-meta').text
        project.lang, project.star_count = extract_lang_and_star_from_meta(meta_data)
        project.name        = content.search('.repo-list-name a').text.split.join
        project.description = content.search('.repo-list-description').text.delete("\n").strip
        project
      end
    end
  end
end

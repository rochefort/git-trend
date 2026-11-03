include GitTrend # rubocop:disable Style/MixinUsage

RSpec.describe GitTrend::Scraper do
  let(:scraper) { Scraper.new }

  describe "settings" do
    subject { scraper.instance_variable_get(:@agent) }

    before do
      allow(ENV).to receive(:[]).with("http_proxy").and_return("http://#{proxy_user}:#{proxy_pass}@#{proxy_addr}:#{proxy_port}")
    end

    let(:proxy_addr) { "192.168.1.99" }
    let(:proxy_port) { 9999 }
    let(:proxy_user) { "proxy_user" }
    let(:proxy_pass) { "proxy_pass" }

    it "uses proxy settings of ENV" do
      aggregate_failures do
        expect(subject.proxy_addr).to eq proxy_addr
        expect(subject.proxy_user).to eq proxy_user
        expect(subject.proxy_pass).to eq proxy_pass
        expect(subject.proxy_port).to eq proxy_port
        expect(subject.user_agent).to eq "git-trend #{VERSION}"
      end
    end
  end

  describe "#get" do
    context "when a network error occurred" do
      before do
        stub_request(:get, Scraper::BASE_URL)
          .to_return(status: 500, body: "[]")
      end

      it { expect { scraper.get }.to raise_error(Exception) }
    end

    context "when the description has utility classes changed by GitHub" do
      before do
        body = <<~HTML
          <html><body>
            <article class="Box-row">
              <h2><a href="/foo/bar">foo / bar</a></h2>
              <p class="col-9 color-fg-muted my-1 tmp-pr-4">A description</p>
            </article>
          </body></html>
        HTML
        stub_request(:get, Scraper::BASE_URL)
          .to_return(status: 200, body: body, headers: { content_type: "text/html" })
      end

      it "gets the description" do
        expect(scraper.get.first.description).to eq "A description"
      end
    end
  end
end

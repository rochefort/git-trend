include GitTrend
RSpec.describe GitTrend::Scraper do
  let(:scraper) { Scraper.new }

  describe "settings" do
    before do
      allow(ENV).to receive(:[]).with("http_proxy").and_return("http://#{proxy_user}:#{proxy_pass}@#{proxy_addr}:#{proxy_port}")
    end
    let(:proxy_addr) { "192.168.1.99" }
    let(:proxy_port) { 9999 }
    let(:proxy_user) { "proxy_user" }
    let(:proxy_pass) { "proxy_pass" }
    subject { scraper.instance_variable_get(:@agent) }
    it "should use proxy settings of ENV" do
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
  end
end

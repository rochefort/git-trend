include GitTrend
RSpec.describe GitTrend::Scraper do
  let(:scraper) { Scraper.new }

  describe 'settings' do
    before do
      allow(ENV).to receive(:[]).with('http_proxy').and_return('http://proxy_user:proxy_pass@192.168.1.99:9999')
    end
    subject { scraper.instance_variable_get(:@agent) }
    its(:user_agent) { should eq "git-trend #{VERSION}" }
    its(:proxy_addr) { should eq '192.168.1.99' }
    its(:proxy_user) { should eq 'proxy_user' }
    its(:proxy_pass) { should eq 'proxy_pass' }
    its(:proxy_port) { should eq 9999 }
  end

  describe '#get' do
    context 'when a network error occurred' do
      before do
        stub_request(:get, Scraper::BASE_URL)
          .to_return(status: 500, body: '[]')
      end
      it { expect { scraper.get }.to raise_error(Exception) }
    end

    context 'when a scraping error occurred' do
      before do
        stub_request(:get, Scraper::BASE_URL)
          .to_return(status: 200, headers: { content_type: 'text/html' }, body: '')
      end
      it { expect { scraper.get }.to raise_error(ScrapeException) }
    end
  end
end

require 'spec_helper'

include GitTrend
RSpec.describe GitTrend::Scraper do

  describe 'proxy settings' do
    before do
      allow(ENV).to receive(:[]).with('http_proxy').and_return('http://proxy_user:proxy_pass@192.168.1.99:9999')
      @scraper = Scraper.new
    end
    subject { @scraper.instance_variable_get(:@agent) }
    its(:proxy_addr) { should eq '192.168.1.99' }
    its(:proxy_user) { should eq 'proxy_user' }
    its(:proxy_pass) { should eq 'proxy_pass' }
    its(:proxy_port) { should eq 9999 }
  end

  describe '#get' do
    before do
      @scraper = Scraper.new
      stub_request_get
    end

    context 'when a network error occurred' do
      before do
        stub_request(:get, Scraper::BASE_URL).
          to_return(:status => 500, :body => '[]')
      end
      it { expect{ @scraper.get }.to raise_error(Exception) }
    end

    context 'with no option' do
      it 'display daily ranking' do
        res = <<-'EOS'.unindent
          | No Name                                                 Star  Fork
          |--- -------------------------------------------------- ------ -----
          |  1 prat0318/json_resume                                  264    15
          |  2 andlabs/ui                                            185     8
          |  3 jessepollak/card                                      174     9
          |  4 fullstackio/FlappySwift                               148    44
          |  5 grant/swift-cheat-sheet                               153    13
          |  6 Flolagale/mailin                                      155     3
          |  7 numbbbbb/the-swift-programming-language-in-chinese    120    31
          |  8 hippyvm/hippyvm                                       113     1
          |  9 neovim/neovim                                          83     8
          | 10 hiphopapp/hiphop                                       77     8
          | 11 interagent/http-api-design                             78     4
          | 12 austinzheng/swift-2048                                 69    16
          | 13 mdznr/What-s-New                                       72     2
          | 14 daneden/animate.css                                    65     6
          | 15 davidmerfield/randomColor                              66     3
          | 16 dawn/dawn                                              62     2
          | 17 greatfire/wiki                                         54     9
          | 18 swift-jp/swift-guide                                   45     9
          | 19 addyosmani/psi                                         49     0
          | 20 mtford90/silk                                          47     0
          | 21 agaue/agaue                                            47     0
          | 22 mentionapp/mntpulltoreact                              46     1
          | 23 mikepenz/AboutLibraries                                45     0
          | 24 PistonDevelopers/piston-workspace                      45     0
          | 25 maxpow4h/swiftz                                        43     1
        EOS
        expect { @scraper.get }.to output(res).to_stdout
      end
    end
  end

  private
    def stub_request_get
      stub_request(:get, Scraper::BASE_URL).
        to_return(
          :status => 200,
          :headers => {content_type: 'text/html'},
          :body => load_http_stub('trending'))
    end
end

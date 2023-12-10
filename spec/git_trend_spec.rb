RSpec.describe GitTrend do
  include GitTrend
  let(:scraper_mock) { instance_double(Scraper) }

  before do
    allow(Scraper).to receive(:new).and_return(scraper_mock)
    stub_request(:get, /.*/)
      .to_return(status: 200, headers: { content_type: "text/html" }, body: load_http_stub("trending"))
  end

  describe "#get" do
    context "normal" do
      before do
        allow(scraper_mock).to receive(:get)
      end

      context "without options" do
        it "Scraper#get call without options" do
          described_class.get
          expect(scraper_mock).to have_received(:get).with(no_args)
        end
      end

      context "parameter is 'ruby'" do
        it "Scraper#get call with 'ruby'" do
          described_class.get("ruby")
          expect(scraper_mock).to have_received(:get).with("ruby")
        end
      end

      context "parameter is :ruby" do
        it "Scraper#get call with :ruby" do
          described_class.get(:ruby)
          expect(scraper_mock).to have_received(:get).with(:ruby)
        end
      end

      context "parameter is since: :weekly" do
        it "Scraper#get call with [nil, :weekly]" do
          described_class.get(since: :weekly)
          expect(scraper_mock).to have_received(:get).with(nil, :weekly)
        end
      end

      context "parameter is since: :week" do
        it "Scraper#get call with [nil, :week]" do
          described_class.get(since: :week)
          expect(scraper_mock).to have_received(:get).with(nil, :week)
        end
      end

      context "parameter is since: :w" do
        it "Scraper#get call with [nil, :w]" do
          described_class.get(since: :w)
          expect(scraper_mock).to have_received(:get).with(nil, :w)
        end
      end

      context "parameters are 'ruby', 'weekly'" do
        it "Scraper#get call with ['ruby', 'weekly']" do
          described_class.get("ruby", "weekly")
          expect(scraper_mock).to have_received(:get).with("ruby", "weekly")
        end
      end

      context "parameters are :ruby, :weekly" do
        it "Scraper#get call with [:ruby, :weekly]" do
          described_class.get(:ruby, :weekly)
          expect(scraper_mock).to have_received(:get).with(:ruby, :weekly)
        end
      end

      context "parameters are language: :ruby, since: :weekly" do
        it "Scraper#get call with [:ruby, :weekly]" do
          described_class.get(language: :ruby, since: :weekly)
          expect(scraper_mock).to have_received(:get).with(:ruby, :weekly)
        end
      end
    end

    context "abnormal" do
      context "when too many parameters" do
        it { expect { described_class.get("ruby", "weekly", "many_params") }.to raise_error(Exception) }
      end
    end

    describe "#languages" do
      before do
        allow(scraper_mock).to receive(:languages)
      end

      it "Scraper#languages call" do
        described_class.languages
        expect(scraper_mock).to have_received(:languages).with(no_args)
      end
    end
  end
end

RSpec.describe GitTrend do
  before do
    stub_request(:get, /.*/)
      .to_return(status: 200, headers: { content_type: 'text/html' }, body: load_http_stub('trending'))
  end

  describe '#get' do
    context 'without options' do
      it 'Scraper#get call without options' do
        expect_any_instance_of(Scraper).to receive(:get).with(no_args)
        GitTrend.get
      end
    end

    context "parameter is 'ruby'" do
      it "Scraper#get call with 'ruby'" do
        expect_any_instance_of(Scraper).to receive(:get).with('ruby')
        GitTrend.get('ruby')
      end
    end

    context 'parameter is :ruby' do
      it 'Scraper#get call with :ruby' do
        expect_any_instance_of(Scraper).to receive(:get).with(:ruby)
        GitTrend.get(:ruby)
      end
    end

    context 'parameter is since: :weekly' do
      it 'Scraper#get call with [nil, :weekly]' do
        expect_any_instance_of(Scraper).to receive(:get).with(nil, :weekly)
        GitTrend.get(since: :weekly)
      end
    end

    context 'parameter is since: :week' do
      it 'Scraper#get call with [nil, :week]' do
        expect_any_instance_of(Scraper).to receive(:get).with(nil, :week)
        GitTrend.get(since: :week)
      end
    end

    context 'parameter is since: :w' do
      it 'Scraper#get call with [nil, :w]' do
        expect_any_instance_of(Scraper).to receive(:get).with(nil, :w)
        GitTrend.get(since: :w)
      end
    end

    context "parameters are 'ruby', 'weekly'" do
      it "Scraper#get call with ['ruby', 'weekly']" do
        expect_any_instance_of(Scraper).to receive(:get).with('ruby', 'weekly')
        GitTrend.get('ruby', 'weekly')
      end
    end

    context 'parameters are :ruby, :weekly' do
      it 'Scraper#get call with [:ruby, :weekly]' do
        expect_any_instance_of(Scraper).to receive(:get).with(:ruby, :weekly)
        GitTrend.get(:ruby, :weekly)
      end
    end

    context 'parameters are language: :ruby, since: :weekly' do
      it 'Scraper#get call with [:ruby, :weekly]' do
        expect_any_instance_of(Scraper).to receive(:get).with(:ruby, :weekly)
        GitTrend.get(language: :ruby, since: :weekly)
      end
    end

    context 'when too many parameters' do
      it { expect { GitTrend.get('ruby', 'weekly', 'many_params') }.to raise_error(Exception) }
    end

    describe '#languages' do
      it 'Scraper#languages call' do
        expect_any_instance_of(Scraper).to receive(:languages).with(no_args)
        GitTrend.languages
      end
    end
  end
end

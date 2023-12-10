include GitTrend # rubocop:disable Style/MixinUsage
RSpec.describe GitTrend::CLI do
  shared_examples "since daily ranking" do |since|
    it "display daily ranking" do
      expect { cli.invoke(:list, [], since: since, description: false) }.to output(dummy_result_without_description).to_stdout
    end
  end

  shared_examples "since weekly ranking" do |since|
    it "display weekly ranking" do
      expect { cli.invoke(:list, [], since: since, description: false) }.to output(dummy_weekly_result).to_stdout
    end
  end

  shared_examples "since monthly ranking" do |since|
    it "display monthly ranking" do
      expect { cli.invoke(:list, [], since: since, description: false) }.to output(dummy_monthly_result).to_stdout
    end
  end

  describe "#list" do
    let(:cli) { CLI.new }

    describe "with -n option" do
      context "with 3" do
        before { stub_request_get("trending") }
        let(:number) { 3 }
        it "display top 3 daily ranking" do
          res = <<-'OUTPUT'.unindent
            |No. Name                                     Lang               Star
            |--- ---------------------------------------- ---------------- ------
            |  1 linexjlin/GPTs                                               445
            |  2 ml-explore/mlx-examples                  Python              161
            |  3 PRIS-CV/DemoFusion                       Jupyter Notebook    169

          OUTPUT
          expect { cli.invoke(:list, [], number: number, description: false) }.to output(res).to_stdout
        end
      end

      context "with over 25" do
        before { stub_request_get("trending") }
        let(:number) { 26 }
        it "display daily ranking" do
          expect { cli.invoke(:list, [], number: number, description: false) }.to output(dummy_result_without_description).to_stdout
        end
      end
    end

    describe "with -l option" do
      context "with ruby" do
        before { stub_request_get("trending/#{language}") }
        let(:language) { "ruby" }

        it "display daily ranking by language" do
          res = <<-'OUTPUT'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 greatghoul/remote-working                Ruby           34
            |  2 huginn/huginn                            Ruby           13
            |  3 jekyll/jekyll                            Ruby           11
            |  4 fastlane/fastlane                        Ruby            6
            |  5 rapid7/metasploit-framework              Ruby            8
            |  6 ankane/pghero                            Ruby           16
            |  7 joemasilotti/daily-log                   Ruby            7
            |  8 hashicorp/vagrant                        Ruby            5
            |  9 fluent/fluentd                           Ruby            5
            | 10 rubygems/rubygems                        Ruby            1
            | 11 otwcode/otwarchive                       Ruby            2
            | 12 freeCodeCamp/devdocs                     Ruby            5
            | 13 gitlabhq/gitlabhq                        Ruby            1
            | 14 gollum/gollum                            Ruby            2
            | 15 ruby/ruby                                Ruby            2
            | 16 TheOdinProject/theodinproject            Ruby            6
            | 17 wpscanteam/wpscan                        Ruby            0
            | 18 mastodon/mastodon                        Ruby           12
            | 19 github/explore                           Ruby            0
            | 20 tradingview/charting-library-examples    Ruby            0
            | 21 jwt/ruby-jwt                             Ruby            0
            | 22 forem/forem                              Ruby            4
            | 23 urbanadventurer/WhatWeb                  Ruby            3
            | 24 chef/chef                                Ruby            0
            | 25 instructure/canvas-lms                   Ruby            0

          OUTPUT
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end

      context "with alloy : when trending is nothing" do
        before { stub_request_get("trending/#{language}") }
        let(:language) { "alloy" }

        it "display the 0cases message" do
          res = <<-'OUTPUT'.unindent
            |It looks like we don’t have any trending repositories.

          OUTPUT
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end
    end

    describe "with -s option" do
      context "with no option" do
        before { stub_request_get("trending?since=") }
        include_examples "since daily ranking", ""
      end

      describe "since daily" do
        before { stub_request_get("trending?since=daily") }
        context "with d" do
          include_examples "since daily ranking", "d"
        end

        context "with day" do
          include_examples "since daily ranking", "day"
        end

        context "with daily" do
          include_examples "since daily ranking", "daily"
        end
      end

      describe "since weekly" do
        before { stub_request_get("trending?since=weekly") }
        context "with w" do
          include_examples "since weekly ranking", "w"
        end

        context "with week" do
          include_examples "since weekly ranking", "week"
        end

        context "with weekly" do
          include_examples "since weekly ranking", "weekly"
        end
      end

      describe "since monthly" do
        before { stub_request_get("trending?since=monthly") }
        context "with m" do
          include_examples "since monthly ranking", "m"
        end

        context "with month" do
          include_examples "since monthly ranking", "month"
        end

        context "with monthly" do
          include_examples "since monthly ranking", "monthly"
        end
      end
    end

    describe "with -d option (or with no option)" do
      after do
        ENV["COLUMNS"] = nil
        ENV["LINES"] = nil
      end

      before do
        stub_request_get("trending")
        ENV["COLUMNS"] = "140"
        ENV["LINES"] = "40"
      end

      context "with no option" do
        it "display daily ranking" do
          expect { cli.invoke(:list, []) }.to output(dummy_result_no_options).to_stdout
        end
      end

      context "terminal width is enough" do
        it "display daily ranking with description" do
          expect { cli.invoke(:list, [], description: true) }.to output(dummy_result_no_options).to_stdout
        end
      end

      context "terminal width is tiny" do
        before do
          ENV["COLUMNS"] = "83" # it is not enough for description.
          ENV["LINES"] = "40"
        end

        it "display daily ranking about the same as no option" do
          expect { cli.invoke(:list, [], description: false) }.to output(dummy_result_without_description).to_stdout
        end
      end
    end

    describe "with -l and -s option" do
      context "with ruby and weekly" do
        before { stub_request_get("trending/#{language}?since=#{since}") }
        let(:language) { "ruby" }
        let(:since) { "weekly" }

        it "display weekly ranking by language" do
          res = <<-'OUTPUT'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 mastodon/mastodon                        Ruby          115
            |  2 community/community                      Ruby           25
            |  3 freeCodeCamp/devdocs                     Ruby           65
            |  4 rapid7/metasploit-framework              Ruby           84
            |  5 github-linguist/linguist                 Ruby           14
            |  6 ankane/pghero                            Ruby           32
            |  7 chatwoot/chatwoot                        Ruby           59
            |  8 department-of-veterans-affairs/vets-api  Ruby            2
            |  9 ekylibre/ekylibre                        Ruby           21
            | 10 mileszs/wicked_pdf                       Ruby            5
            | 11 elastic/elasticsearch-rails              Ruby            2
            | 12 heartcombo/devise                        Ruby           16
            | 13 aws/aws-sdk-ruby                         Ruby            2
            | 14 endoflife-date/endoflife.date            Ruby           19
            | 15 jekyll/jekyll                            Ruby           50
            | 16 heartcombo/simple_form                   Ruby            6
            | 17 thoughtbot/shoulda-matchers              Ruby            5
            | 18 spree/spree                              Ruby           13
            | 19 solidusio/solidus                        Ruby            8
            | 20 huginn/huginn                            Ruby           67
            | 21 CanCanCommunity/cancancan                Ruby            2
            | 22 tradingview/charting-library-examples    Ruby            3
            | 23 kaminari/kaminari                        Ruby            5
            | 24 rubocop/rubocop                          Ruby           10
            | 25 paper-trail-gem/paper_trail              Ruby            3

          OUTPUT
          expect { cli.invoke(:list, [], language: language, since: since, description: false) }.to output(res).to_stdout
        end
      end
    end
  end

  describe "#languages" do
    before { stub_request_get("trending") }
    let(:cli) { CLI.new }

    context "with no option" do
      it "display languages" do
        expect { cli.languages }.to output(include("C++", "HTML", "Ruby")).to_stdout
      end
    end
  end

  private

    def stub_request_get(stub_url_path, stub_file_name = nil)
      url = Scraper::BASE_HOST.dup
      url << "/#{stub_url_path}" if stub_url_path
      uri = URI.parse(url)
      stub_file = stub_file_name || stub_url_path
      stub_request(:get, uri)
        .to_return(
          status: 200,
          headers: { content_type: "text/html" },
          body: load_http_stub(stub_file)
        )
    end

    def dummy_result_without_description
      <<-'OUTPUT'.unindent
        |No. Name                                       Lang               Star
        |--- ------------------------------------------ ---------------- ------
        |  1 linexjlin/GPTs                                                 445
        |  2 ml-explore/mlx-examples                    Python              161
        |  3 PRIS-CV/DemoFusion                         Jupyter Notebook    169
        |  4 jmpoep/vmprotect-3.5.1                     C++                 489
        |  5 prasanthrangan/hyprdots                    Shell                21
        |  6 MichaelYuhe/ai-group-tabs                  TypeScript          230
        |  7 mli/paper-reading                                              129
        |  8 SuperDuperDB/superduperdb                  Python              497
        |  9 ByteByteGoHq/system-design-101                                 268
        | 10 yformer/EfficientSAM                       Jupyter Notebook    117
        | 11 xuchengsheng/spring-reading                Java                413
        | 12 Flode-Labs/vid2densepose                   Python              164
        | 13 huggingface/optimum-nvidia                 Python              133
        | 14 sweepai/sweep                              Python               55
        | 15 practical-tutorials/project-based-learning                    2058
        | 16 home-assistant/core                        Python               33
        | 17 100xdevs-cohort-2/assignments              JavaScript          117
        | 18 kgrzybek/modular-monolith-with-ddd         C#                   21
        | 19 rmcelreath/stat_rethinking_2024            R                    41
        | 20 jackfrued/Python-100-Days                  Python              192
        | 21 01-ai/Yi                                   Python               18
        | 22 facebookresearch/Pearl                     Python               95
        | 23 zzzgydi/clash-verge                        TypeScript           31
        | 24 ytdl-org/youtube-dl                        Python               24
        | 25 dunglas/frankenphp                         Go                   53

      OUTPUT
    end

    def dummy_result_no_options
      <<-'OUTPUT'.unindent
        |No. Name                                       Lang               Star Description
        |--- ------------------------------------------ ---------------- ------ ---------------------------------------------------------------------
        |  1 linexjlin/GPTs                                                 445 leaked prompts of GPTs
        |  2 ml-explore/mlx-examples                    Python              161 Examples in the MLX framework
        |  3 PRIS-CV/DemoFusion                         Jupyter Notebook    169 Let us democratise high-resolution generation! (arXiv 2023)
        |  4 jmpoep/vmprotect-3.5.1                     C++                 489
        |  5 prasanthrangan/hyprdots                    Shell                21 // Aesthetic, dynamic and minimal dots for Arch hyprland
        |  6 MichaelYuhe/ai-group-tabs                  TypeScript          230 A Chrome extension helps you group your tabs with AI.
        |  7 mli/paper-reading                                              129 深度学习经典、新论文逐段精读
        |  8 SuperDuperDB/superduperdb                  Python              497 🔮 SuperDuperDB: Bring AI to your database: Integrate, train and m...
        |  9 ByteByteGoHq/system-design-101                                 268 Explain complex systems using visuals and simple terms. Help you p...
        | 10 yformer/EfficientSAM                       Jupyter Notebook    117 EfficientSAM: Leveraged Masked Image Pretraining for Efficient Seg...
        | 11 xuchengsheng/spring-reading                Java                413 涵盖了 Spring 框架的核心概念和关键功能，包括控制反转（IOC）容器的...
        | 12 Flode-Labs/vid2densepose                   Python              164 Convert your videos to densepose and use it on MagicAnimate
        | 13 huggingface/optimum-nvidia                 Python              133
        | 14 sweepai/sweep                              Python               55 Sweep: AI-powered Junior Developer for small features and bug fixes.
        | 15 practical-tutorials/project-based-learning                    2058 Curated list of project-based tutorials
        | 16 home-assistant/core                        Python               33 🏡 Open source home automation that puts local control and privacy...
        | 17 100xdevs-cohort-2/assignments              JavaScript          117
        | 18 kgrzybek/modular-monolith-with-ddd         C#                   21 Full Modular Monolith application with Domain-Driven Design approach.
        | 19 rmcelreath/stat_rethinking_2024            R                    41
        | 20 jackfrued/Python-100-Days                  Python              192 Python - 100天从新手到大师
        | 21 01-ai/Yi                                   Python               18 A series of large language models trained from scratch by develope...
        | 22 facebookresearch/Pearl                     Python               95 A Production-ready Reinforcement Learning AI Agent Library brought...
        | 23 zzzgydi/clash-verge                        TypeScript           31 A Clash GUI based on tauri. Supports Windows, macOS and Linux.
        | 24 ytdl-org/youtube-dl                        Python               24 Command-line program to download videos from YouTube.com and other...
        | 25 dunglas/frankenphp                         Go                   53 The modern PHP app server

      OUTPUT
    end

    def dummy_weekly_result
      <<-'OUTPUT'.unindent
        |No. Name                                       Lang               Star
        |--- ------------------------------------------ ---------------- ------
        |  1 LC044/WeChatMsg                            Python            10719
        |  2 microsoft/TaskWeaver                       Python             1957
        |  3 facebookresearch/seamless_communication    C                  1568
        |  4 lllyasviel/Fooocus                         Python             3406
        |  5 sherlock-project/sherlock                  Python              996
        |  6 pytorch-labs/gpt-fast                      Python             2147
        |  7 comfyanonymous/ComfyUI                     Python             1518
        |  8 VikParuchuri/marker                        Python             1497
        |  9 xuchengsheng/spring-reading                Java                637
        | 10 Mozilla-Ocho/llamafile                     C++                1833
        | 11 go-gost/gost                               Go                  487
        | 12 microsoft/PowerToys                        C#                  905
        | 13 songquanpeng/one-api                       Go                  323
        | 14 nocodb/nocodb                              TypeScript          392
        | 15 AleoHQ/leo                                 Rust                744
        | 16 modularml/mojo                             Jupyter Notebook    386
        | 17 gkd-kit/gkd                                Kotlin             1272
        | 18 danny-avila/LibreChat                      TypeScript          647
        | 19 practical-tutorials/project-based-learning                    1670
        | 20 pocketbase/pocketbase                      Go                  457
        | 21 symfony/symfony                            PHP                  35
        | 22 awesome-selfhosted/awesome-selfhosted                         2239
        | 23 upscayl/upscayl                            TypeScript          266
        | 24 coolsnowwolf/lede                          C                   132
        | 25 QwenLM/Qwen                                Python              377

      OUTPUT
    end

    def dummy_monthly_result
      <<-'OUTPUT'.unindent
        |No. Name                                     Lang               Star
        |--- ---------------------------------------- ---------------- ------
        |  1 SawyerHood/draw-a-ui                     TypeScript        11761
        |  2 Stability-AI/generative-models           Python             7286
        |  3 microsoft/ML-For-Beginners               HTML               9252
        |  4 microsoft/generative-ai-for-beginners    Jupyter Notebook  15174
        |  5 lllyasviel/Fooocus                       Python            10023
        |  6 langchain-ai/opengpts                    Rich Text Format   3978
        |  7 facebookresearch/seamless_communication  C                  2607
        |  8 microsoft/AI-For-Beginners               Jupyter Notebook   5708
        |  9 tldraw/tldraw                            TypeScript         6750
        | 10 atomicals/atomicals-js                   TypeScript          627
        | 11 githubnext/monaspace                     TypeScript         9912
        | 12 udlbook/udlbook                          Jupyter Notebook   1551
        | 13 comfyanonymous/ComfyUI                   Python             4197
        | 14 langgenius/dify                          TypeScript         2906
        | 15 lobehub/lobe-chat                        TypeScript         2622
        | 16 luosiallen/latent-consistency-model      Python             2706
        | 17 daveshap/OpenAI_Agent_Swarm              Python             2310
        | 18 chenzomi12/DeepLearningSystem            Jupyter Notebook   1760
        | 19 biomejs/biome                            Rust               2372
        | 20 openai/openai-python                     Python             2811
        | 21 AppFlowy-IO/AppFlowy                     Dart               3071
        | 22 saadeghi/daisyui                         Svelte             1773
        | 23 nlohmann/json                            C++                1080
        | 24 SillyTavern/SillyTavern                  JavaScript         1566
        | 25 1Panel-dev/1Panel                        Go                 1950

      OUTPUT
    end
end

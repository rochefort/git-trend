require "git_trend/scraper"

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
    let(:cli) { described_class.new }

    describe "with -n option" do
      context "with 3" do
        before { stub_request_get("trending") }

        let(:number) { 3 }

        it "display top 3 daily ranking" do
          res = <<-OUTPUT.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 thedotmack/claude-mem                    TypeScript   1138
            |  2 vercel-labs/agent-desktop                Rust         3792
            |  3 max-sixty/worktrunk                      Rust          437

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
          res = <<-OUTPUT.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 Homebrew/homebrew-cask                   Ruby            4
            |  2 we-promise/sure                          Ruby           20
            |  3 matteocrippa/awesome-swift               Ruby            1
            |  4 rails/rails                              Ruby            3
            |  5 huginn/huginn                            Ruby           23
            |  6 citation-style-language/styles           Ruby            1
            |  7 Freika/dawarich                          Ruby           16
            |  8 opf/openproject                          Ruby           36
            |  9 github/explore                           Ruby            2
            | 10 dependabot/demo                          Ruby            0
            | 11 gitlabhq/gitlabhq                        Ruby            1
            | 12 ruby/gem_rbs_collection                  Ruby            0
            | 13 mastodon/mastodon                        Ruby            5
            | 14 docusealco/docuseal                      Ruby            9
            | 15 danbooru/danbooru                        Ruby            1
            | 16 ubicloud/ubicloud                        Ruby            3
            | 17 tobymao/18xx                             Ruby            1

          OUTPUT
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end

      context "with alloy : when trending is nothing" do
        before { stub_request_get("trending/#{language}") }

        let(:language) { "alloy" }

        it "display the 0cases message" do
          res = <<-OUTPUT.unindent
            |It looks like we don’t have any trending repositories.

          OUTPUT
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end
    end

    describe "with -s option" do
      context "with no option" do
        before { stub_request_get("trending?since=") }

        it_behaves_like "since daily ranking", ""
      end

      describe "since daily" do
        before { stub_request_get("trending?since=daily") }

        context "with d" do
          it_behaves_like "since daily ranking", "d"
        end

        context "with day" do
          it_behaves_like "since daily ranking", "day"
        end

        context "with daily" do
          it_behaves_like "since daily ranking", "daily"
        end
      end

      describe "since weekly" do
        before { stub_request_get("trending?since=weekly") }

        context "with w" do
          it_behaves_like "since weekly ranking", "w"
        end

        context "with week" do
          it_behaves_like "since weekly ranking", "week"
        end

        context "with weekly" do
          it_behaves_like "since weekly ranking", "weekly"
        end
      end

      describe "since monthly" do
        before { stub_request_get("trending?since=monthly") }

        context "with m" do
          it_behaves_like "since monthly ranking", "m"
        end

        context "with month" do
          it_behaves_like "since monthly ranking", "month"
        end

        context "with monthly" do
          it_behaves_like "since monthly ranking", "monthly"
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

      context "terminal width is unknown" do
        before do
          ENV["COLUMNS"] = nil
          allow(IO).to receive(:console).and_return(nil)
        end

        it "display daily ranking with the default width" do
          expect { cli.invoke(:list, []) }.to output(dummy_result_without_description).to_stdout
        end
      end
    end

    describe "with -l and -s option" do
      context "with ruby and weekly" do
        before { stub_request_get("trending/#{language}?since=#{since}") }

        let(:language) { "ruby" }
        let(:since) { "weekly" }

        it "display weekly ranking by language" do
          res = <<-OUTPUT.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 huginn/huginn                            Ruby          136
            |  2 opf/openproject                          Ruby          257
            |  3 chatwoot/chatwoot                        Ruby          409
            |  4 github/explore                           Ruby           15
            |  5 docusealco/docuseal                      Ruby          184
            |  6 Homebrew/homebrew-cask                   Ruby           23
            |  7 Freika/dawarich                          Ruby           79
            |  8 ruby/rubygems                            Ruby            6
            |  9 we-promise/sure                          Ruby           91
            | 10 Homebrew/brew                            Ruby          102
            | 11 zammad/zammad                            Ruby           36
            | 12 hashicorp/vagrant                        Ruby            8
            | 13 mastodon/mastodon                        Ruby           35
            | 14 jekyll/jekyll                            Ruby           28
            | 15 antiwork/gumroad                         Ruby           57
            | 16 rails/rails                              Ruby           14
            | 17 spree/spree                              Ruby           31
            | 18 discourse/discourse                      Ruby           43
            | 19 postalserver/postal                      Ruby           23
            | 20 rubocop/rubocop                          Ruby            4
            | 21 ruby/gem_rbs_collection                  Ruby            0
            | 22 urbanadventurer/WhatWeb                  Ruby           63

          OUTPUT
          expect { cli.invoke(:list, [], language: language, since: since, description: false) }.to output(res).to_stdout
        end
      end
    end

    describe "with --verbose option" do
      context "when a network error occurred" do
        before { stub_request(:get, GitTrend::Scraper::BASE_URL).to_return(status: 500) }

        it "display the error and its backtrace" do
          expect { cli.invoke(:list, [], verbose: true) }.to output(/An unexpected .+ has occurred.+scraper\.rb:\d+/m).to_stdout
        end
      end
    end
  end

  describe "#languages" do
    before { stub_request_get("trending") }

    let(:cli) { described_class.new }

    context "with no option" do
      it "display languages" do
        expect { cli.languages }.to output(include("C++", "HTML", "Ruby")).to_stdout
      end
    end
  end

  private

    def stub_request_get(stub_url_path, stub_file_name = nil)
      url = GitTrend::Scraper::BASE_HOST.dup
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
      <<-OUTPUT.unindent
        |No. Name                                     Lang         Star
        |--- ---------------------------------------- ---------- ------
        |  1 thedotmack/claude-mem                    TypeScript   1138
        |  2 vercel-labs/agent-desktop                Rust         3792
        |  3 max-sixty/worktrunk                      Rust          437
        |  4 JustVugg/colibri                         C             803
        |  5 mattpocock/skills                        Shell        1164
        |  6 p-e-w/heretic                            Python        699
        |  7 spotify/portal-ai-plugins                TypeScript     94
        |  8 floci-io/floci                           Java          219
        |  9 Usagi-org/ai-goofish-monitor             Python        204
        | 10 anomalyco/hex                            Rust         1134
        | 11 D4Vinci/Scrapling                        Python       1658
        | 12 shiyu-coder/Kronos                       Python        503
        | 13 Donchitos/Claude-Code-Game-Studios       Shell        1181

      OUTPUT
    end

    def dummy_result_no_options
      <<-OUTPUT.unindent
        |No. Name                                     Lang         Star Description
        |--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
        |  1 thedotmack/claude-mem                    TypeScript   1138 Persistent Context Across Sessions for Every Agent – Captures everything ...
        |  2 vercel-labs/agent-desktop                Rust         3792 Computer use CLI for AI agents
        |  3 max-sixty/worktrunk                      Rust          437 Worktrunk is a CLI for Git worktree management, designed for parallel AI a...
        |  4 JustVugg/colibri                         C             803 A hierarchical inference engine for frontier MoE models: hot experts on th...
        |  5 mattpocock/skills                        Shell        1164 Skills for Real Engineers. Straight from my .agents directory.
        |  6 p-e-w/heretic                            Python        699 Training-free language model modification: Remove censorship, suppress slo...
        |  7 spotify/portal-ai-plugins                TypeScript     94
        |  8 floci-io/floci                           Java          219 Light, fluffy, and always free - The AWS Local Emulator alternative
        |  9 Usagi-org/ai-goofish-monitor             Python        204 基于 Playwright 和AI实现的闲鱼多任务实时/定时监控与智能分析系统，配备了功...
        | 10 anomalyco/hex                            Rust         1134 Local voice dictation for mac, windows and linux
        | 11 D4Vinci/Scrapling                        Python       1658 🕷️ The BEST Web Scraping framework that handles everything from a single...
        | 12 shiyu-coder/Kronos                       Python        503 Kronos: A Foundation Model for the Language of Financial Markets
        | 13 Donchitos/Claude-Code-Game-Studios       Shell        1181 Turn Claude Code into a full game dev studio — 49 AI agents, 72 workflow ...

      OUTPUT
    end

    def dummy_weekly_result
      <<-OUTPUT.unindent
        |No. Name                                     Lang         Star
        |--- ---------------------------------------- ---------- ------
        |  1 Nutlope/hallmark                         CSS         10517
        |  2 thedotmack/claude-mem                    TypeScript   7255
        |  3 pingdotgg/t3code                         TypeScript   9770
        |  4 obra/superpowers                         Shell        5956
        |  5 pbakaus/impeccable                       Rust        11754
        |  6 AgriciDaniel/claude-seo                  Python       4091
        |  7 JetBrains/thinkrail                      TypeScript   4812
        |  8 anthropics/skills                        Python       2828
        |  9 jakubkrehel/skills                       Markdown     1707
        | 10 multica-ai/andrej-karpathy-skills                     4397
        | 11 ghostty-org/ghostty                      Zig           687
        | 12 cloudflare/security-audit-skill          JavaScript   9155
        | 13 hyprwm/Hyprland                          C++           662
        | 14 TauricResearch/TradingAgents             Python       4603
        | 15 max-sixty/worktrunk                      Rust          406
        | 16 affaan-m/ECC                             JavaScript   6201

      OUTPUT
    end

    def dummy_monthly_result
      <<-OUTPUT.unindent
        |No. Name                                     Lang         Star
        |--- ---------------------------------------- ---------- ------
        |  1 morluto/rea                              TypeScript 422104
        |  2 cloudflare/security-audit-skill          JavaScript  33474
        |  3 Nutlope/hallmark                         CSS         16306
        |  4 heygen-com/hyperframes                   TypeScript  22290
        |  5 debpalash/VoiceStudio                    Python      47605
        |  6 anthropics/knowledge-work-plugins        Python       8614
        |  7 NationalSecurityAgency/ghidra            Java        17043
        |  8 ranxianglei/billion-context              TypeScript   3213
        |  9 thedotmack/claude-mem                    TypeScript  15681
        | 10 pingdotgg/t3code                         TypeScript  15731
        | 11 tester-army/e2e                          TypeScript  11344
        | 12 pbakaus/impeccable                       Rust        26586
        | 13 earthtojake/text-to-cad                  Python       8535
        | 14 mksglu/context-mode                      TypeScript   8531
        | 15 anthropics/claude-plugins-official       Python       8715
        | 16 tashfeenahmed/freellmapi                 TypeScript  16329
        | 17 michael-denyer/pstack-claude             JavaScript   3018

      OUTPUT
    end
end

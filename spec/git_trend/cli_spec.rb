# rubocop:disable Style/TrailingWhitespace
include GitTrend
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
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 alexanderepstein/Bash-Snippets           Shell        1111
            |  2 jaredreich/pell                          JavaScript    665
            |  3 azat-co/practicalnode                    JavaScript    440

          EOS
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
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 rails/activestorage                      Ruby           25
            |  2 jondot/awesome-react-native              Ruby           21
            |  3 jekyll/jekyll                            Ruby           18
            |  4 athityakumar/colorls                     Ruby           16
            |  5 rails/rails                              Ruby           10
            |  6 discourse/discourse                      Ruby           12
            |  7 openjournals/jose                        Ruby           11
            |  8 Homebrew/brew                            Ruby           10
            |  9 fastlane/fastlane                        Ruby            9
            | 10 pinterest/it-cpe-cookbooks               Ruby           10
            | 11 elastic/logstash                         Ruby            9
            | 12 mitchellh/vagrant                        Ruby            9
            | 13 caskroom/homebrew-cask                   Ruby            5
            | 14 rails/webpacker                          Ruby            8
            | 15 jcs/lobsters                             Ruby            8
            | 16 tootsuite/mastodon                       Ruby            6
            | 17 rapid7/metasploit-framework              Ruby            7
            | 18 learnetto/calreact                       Ruby            7
            | 19 gitlabhq/gitlabhq                        Ruby            5
            | 20 sass/sass                                Ruby            6
            | 21 thoughtbot/administrate                  Ruby            6
            | 22 CocoaPods/CocoaPods                      Ruby            5
            | 23 huginn/huginn                            Ruby            5
            | 24 airblade/paper_trail                     Ruby            5
            | 25 rmosolgo/graphql-ruby                    Ruby            5

          EOS
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end

      context "with alloy : when star and fork count is nothing" do
        before { stub_request_get("trending/#{language}") }
        let(:language) { "alloy" }

        it "display daily ranking by language" do
          res = <<-'EOS'.unindent
            |No. Name                                        Lang         Star
            |--- ------------------------------------------- ---------- ------
            |  1 danielbayley/Ableton-Live-tools             Alloy           0
            |  2 DavW/midihack                               Alloy           0
            |  3 mark-henry/ableton-experiment               Alloy           0
            |  4 Iyouboushi/mIRC-BattleArena                 Alloy           0
            |  5 adamjmurray/js-live-api-humanize-midi-clips Alloy           0
            |  6 Binomio/bootstrap-base-song-for-live9       Alloy           0
            |  7 lorin/alloy-fish                            Alloy           0
            |  8 devd/websecmodel                            Alloy           0
            |  9 kepae/alloy-coin                            Alloy           0
            | 10 pron/amazon-snapshot-spec                   Alloy           0
            | 11 SaberMirzaei/Alloy-Model-of-MCA             Alloy           0
            | 12 rossgore/alloy-tutorial                     Alloy           0
            | 13 uwplse/memsynth                             Alloy           0
            | 14 fstakem/alloy_book                          Alloy           0
            | 15 aishamidori/cs195y-final                    Alloy           0
            | 16 samueltcsantos/logica.alloy                 Alloy           0
            | 17 mravella/maya_model                         Alloy           0
            | 18 salesfelipe/projetoDeLogica                 Alloy           0
            | 19 BGCX261/zigbee-alloy-svn-to-git             Alloy           0
            | 20 millerns/ReliableDataTransfer               Alloy           0
            | 21 ArcherCraftStore/ArcherCraft_Maya           Alloy           0
            | 22 cpmpercussion/teslamusic                    Alloy           0
            | 23 z64/track-52314                             Alloy           0
            | 24 kmcallister/gc-models                       Alloy           0
            | 25 Echtzeitsysteme/cardygan                    Alloy           0

          EOS
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
          expect { cli.invoke(:list, [], description: true) }.to output(dummy_result_without_description).to_stdout
        end
      end
    end

    describe "with -l and -s option" do
      context "with ruby and weekly" do
        before { stub_request_get("trending/#{language}?since=#{since}") }
        let(:language) { "ruby" }
        let(:since) { "weekly" }

        it "display weekly ranking by language" do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 athityakumar/colorls                     Ruby          442
            |  2 rails/activestorage                      Ruby          185
            |  3 jondot/awesome-react-native              Ruby          143
            |  4 fastlane/fastlane                        Ruby          117
            |  5 rails/rails                              Ruby           98
            |  6 Homebrew/brew                            Ruby          101
            |  7 jekyll/jekyll                            Ruby           92
            |  8 discourse/discourse                      Ruby           78
            |  9 tootsuite/mastodon                       Ruby           63
            | 10 openebs/openebs                          Ruby           66
            | 11 lewagon/setup                            Ruby           61
            | 12 DeathKing/Learning-SICP                  Ruby           51
            | 13 huginn/huginn                            Ruby           50
            | 14 sass/sass                                Ruby           48
            | 15 atech/postal                             Ruby           46
            | 16 mitchellh/vagrant                        Ruby           46
            | 17 exercism/exercism.io                     Ruby           46
            | 18 caskroom/homebrew-cask                   Ruby           32
            | 19 rapid7/metasploit-framework              Ruby           35
            | 20 gitlabhq/gitlabhq                        Ruby           37
            | 21 elastic/logstash                         Ruby           36
            | 22 stympy/faker                             Ruby           32
            | 23 Homebrew/homebrew-core                   Ruby           22
            | 24 ruby/ruby                                Ruby           34
            | 25 rails/webpacker                          Ruby           34

          EOS
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
        expect { cli.languages }.to output(dummy_languages).to_stdout
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
          body: load_http_stub(stub_file))
    end

    def dummy_result_without_description
      <<-'EOS'.unindent
        |No. Name                                     Lang               Star
        |--- ---------------------------------------- ---------------- ------
        |  1 alexanderepstein/Bash-Snippets           Shell              1111
        |  2 jaredreich/pell                          JavaScript          665
        |  3 azat-co/practicalnode                    JavaScript          440
        |  4 shieldfy/API-Security-Checklist                              427
        |  5 d4l3k/go-pry                             Go                  419
        |  6 Kristories/awesome-guidelines                                382
        |  7 iogf/sukhoi                              Python              302
        |  8 wearehive/project-guidelines             JavaScript          254
        |  9 gpujs/gpu.js                             JavaScript          260
        | 10 geekplux/markvis                         JavaScript          230
        | 11 tensorflow/nmt                           Python              212
        | 12 gitpoint/git-point                       JavaScript          212
        | 13 coells/100days                           Jupyter Notebook    199
        | 14 scwang90/SmartRefreshLayout              Java                198
        | 15 zeit/now                                 JavaScript          197
        | 16 walmik/scribbletune                      JavaScript          174
        | 17 cdflynn/turn-layout-manager              Java                165
        | 18 vuejs/vue                                JavaScript          157
        | 19 sdras/intro-to-vue                       Vue                 153
        | 20 moinism/botui                            JavaScript          150
        | 21 Tanibox/tania                            CSS                 153
        | 22 tensorflow/tensorflow                    C++                 116
        | 23 tarek360/RichPath                        Java                150
        | 24 woxingxiao/SlidingUpPanelLayout          Java                143
        | 25 kristian-lange/net-glimpse               JavaScript          141

      EOS
    end

    def dummy_result_no_options
      <<-'EOS'.unindent
        |No. Name                                     Lang               Star Description                                                            
        |--- ---------------------------------------- ---------------- ------ -----------------------------------------------------------------------
        |  1 alexanderepstein/Bash-Snippets           Shell              1111 A collection of small bash scripts for heavy terminal users            
        |  2 jaredreich/pell                          JavaScript          665 📝 the simplest and smallest (1kB) WYSIWYG text editor for web, with...
        |  3 azat-co/practicalnode                    JavaScript          440 Practical Node.js, 1st and 2nd Editions [Apress]                       
        |  4 shieldfy/API-Security-Checklist                              427 Checklist of the most important security countermeasures when design...
        |  5 d4l3k/go-pry                             Go                  419 An interactive REPL for Go that allows you to drop into your code at...
        |  6 Kristories/awesome-guidelines                                382 A curated list of high quality coding style conventions and standards. 
        |  7 iogf/sukhoi                              Python              302 Minimalist and powerful Web Crawler.                                   
        |  8 wearehive/project-guidelines             JavaScript          254 A set of best practices for JavaScript projects                        
        |  9 gpujs/gpu.js                             JavaScript          260 GPU Accelerated JavaScript                                             
        | 10 geekplux/markvis                         JavaScript          230 make visualization in markdown. 📊📈                                   
        | 11 tensorflow/nmt                           Python              212 TensorFlow Neural Machine Translation Tutorial                         
        | 12 gitpoint/git-point                       JavaScript          212 ⚡️ GitHub for iOS. Built with React Native.                            
        | 13 coells/100days                           Jupyter Notebook    199 100 days of algorithms                                                 
        | 14 scwang90/SmartRefreshLayout              Java                198 Android智能下拉刷新框架，支持越界回弹，集成了几十种炫酷的Header和 Fo...
        | 15 zeit/now                                 JavaScript          197 Universal, serverless, single-command deployment                       
        | 16 walmik/scribbletune                      JavaScript          174 Generate musical patterns with JavaScript and export as MIDI files u...
        | 17 cdflynn/turn-layout-manager              Java                165 A carousel layout manager for RecyclerView                             
        | 18 vuejs/vue                                JavaScript          157 A progressive, incrementally-adoptable JavaScript framework for buil...
        | 19 sdras/intro-to-vue                       Vue                 153 Workshop Materials for my Introduction to Vue.js Workshop              
        | 20 moinism/botui                            JavaScript          150 🤖 A JavaScript framework to create conversational UIs                 
        | 21 Tanibox/tania                            CSS                 153 A PHP based, free, and open source farming management system.          
        | 22 tensorflow/tensorflow                    C++                 116 Computation using data flow graphs for scalable machine learning       
        | 23 tarek360/RichPath                        Java                150 💪 Rich Android Path. 🤡 Draw as you want. 🎉 Animate much as you can. 
        | 24 woxingxiao/SlidingUpPanelLayout          Java                143 A vertical-handled and multi-panel support SlidingPanelLayout. 一个... 
        | 25 kristian-lange/net-glimpse               JavaScript          141 1) Real-time visualization of network traffic (Ethernet and Internet...

      EOS
    end

    def dummy_weekly_result
      <<-'EOS'.unindent
        |No. Name                                           Lang               Star
        |--- ---------------------------------------------- ---------------- ------
        |  1 shieldfy/API-Security-Checklist                                   5990
        |  2 coells/100days                                 Jupyter Notebook   3977
        |  3 jaredreich/pell                                JavaScript         3623
        |  4 wearehive/project-guidelines                   JavaScript         3263
        |  5 scwang90/SmartRefreshLayout                    Java               2186
        |  6 vadimdemedes/ink                               JavaScript         1686
        |  7 gitpoint/git-point                             JavaScript         1326
        |  8 ApolloAuto/apollo                              C++                1193
        |  9 samccone/bundle-buddy                          JavaScript         1225
        | 10 alexanderepstein/Bash-Snippets                 Shell              1126
        | 11 gatsbyjs/gatsby                                JavaScript         1114
        | 12 d4l3k/go-pry                                   Go                 1108
        | 13 vuejs/vue                                      JavaScript          979
        | 14 tensorflow/tensorflow                          C++                 790
        | 15 sdmg15/Best-websites-a-programmer-should-visit                     931
        | 16 gpujs/gpu.js                                   JavaScript          958
        | 17 walmik/scribbletune                            JavaScript          909
        | 18 nitin42/terminal-in-react                      JavaScript          822
        | 19 tensorflow/nmt                                 Python              781
        | 20 AnthonyCalandra/modern-cpp-features                                797
        | 21 howtographql/howtographql                      TypeScript          773
        | 22 mmcloughlin/globe                              Go                  735
        | 23 Yoctol/messaging-apis                          JavaScript          653
        | 24 azat-co/practicalnode                          JavaScript          638
        | 25 evilsocket/xray                                Go                  619

      EOS
    end

    def dummy_monthly_result
      <<-'EOS'.unindent
        |No. Name                                           Lang               Star
        |--- ---------------------------------------------- ---------------- ------
        |  1 shieldfy/API-Security-Checklist                                   5990
        |  2 coells/100days                                 Jupyter Notebook   3977
        |  3 jaredreich/pell                                JavaScript         3623
        |  4 wearehive/project-guidelines                   JavaScript         3263
        |  5 scwang90/SmartRefreshLayout                    Java               2186
        |  6 vadimdemedes/ink                               JavaScript         1686
        |  7 gitpoint/git-point                             JavaScript         1326
        |  8 ApolloAuto/apollo                              C++                1193
        |  9 samccone/bundle-buddy                          JavaScript         1225
        | 10 alexanderepstein/Bash-Snippets                 Shell              1126
        | 11 gatsbyjs/gatsby                                JavaScript         1114
        | 12 d4l3k/go-pry                                   Go                 1108
        | 13 vuejs/vue                                      JavaScript          979
        | 14 tensorflow/tensorflow                          C++                 790
        | 15 sdmg15/Best-websites-a-programmer-should-visit                     931
        | 16 gpujs/gpu.js                                   JavaScript          958
        | 17 walmik/scribbletune                            JavaScript          909
        | 18 nitin42/terminal-in-react                      JavaScript          822
        | 19 tensorflow/nmt                                 Python              781
        | 20 AnthonyCalandra/modern-cpp-features                                797
        | 21 howtographql/howtographql                      TypeScript          773
        | 22 mmcloughlin/globe                              Go                  735
        | 23 Yoctol/messaging-apis                          JavaScript          653
        | 24 azat-co/practicalnode                          JavaScript          638
        | 25 evilsocket/xray                                Go                  619

      EOS
    end

    def dummy_languages
      <<-'EOS'.unindent
        |1C Enterprise
        |ABAP
        |ABNF
        |ActionScript
        |Ada
        |Agda
        |AGS Script
        |Alloy
        |Alpine Abuild
        |AMPL
        |Ant Build System
        |ANTLR
        |ApacheConf
        |Apex
        |API Blueprint
        |APL
        |Apollo Guidance Computer
        |AppleScript
        |Arc
        |Arduino
        |AsciiDoc
        |ASN.1
        |ASP
        |AspectJ
        |Assembly
        |ATS
        |Augeas
        |AutoHotkey
        |AutoIt
        |Awk
        |Batchfile
        |Befunge
        |Bison
        |BitBake
        |Blade
        |BlitzBasic
        |BlitzMax
        |Bluespec
        |Boo
        |Brainfuck
        |Brightscript
        |Bro
        |C
        |C#
        |C++
        |C-ObjDump
        |C2hs Haskell
        |Cap'n Proto
        |CartoCSS
        |Ceylon
        |Chapel
        |Charity
        |ChucK
        |Cirru
        |Clarion
        |Clean
        |Click
        |CLIPS
        |Clojure
        |Closure Templates
        |CMake
        |COBOL
        |CoffeeScript
        |ColdFusion
        |ColdFusion CFC
        |COLLADA
        |Common Lisp
        |Component Pascal
        |Cool
        |Coq
        |Cpp-ObjDump
        |Creole
        |Crystal
        |CSON
        |Csound
        |Csound Document
        |Csound Score
        |CSS
        |CSV
        |Gherkin
        |Cuda
        |CWeb
        |Cycript
        |Cython
        |D
        |D-ObjDump
        |Darcs Patch
        |Dart
        |desktop
        |Diff
        |DIGITAL Command Language
        |DM
        |DNS Zone
        |Dockerfile
        |Dogescript
        |DTrace
        |Dylan
        |E
        |Eagle
        |EBNF
        |eC
        |Ecere Projects
        |ECL
        |ECLiPSe
        |edn
        |Eiffel
        |EJS
        |Elixir
        |Elm
        |Emacs Lisp
        |EmberScript
        |EQ
        |Erlang
        |F#
        |Factor
        |Fancy
        |Fantom
        |Filebench WML
        |Filterscript
        |fish
        |FLUX
        |Formatted
        |Forth
        |Fortran
        |FreeMarker
        |Frege
        |G-code
        |Game Maker Language
        |GAMS
        |GAP
        |GCC Machine Description
        |GDB
        |GDScript
        |Genie
        |Genshi
        |Gentoo Ebuild
        |Gentoo Eclass
        |Gettext Catalog
        |Gherkin
        |GLSL
        |Glyph
        |GN
        |Gnuplot
        |Go
        |Golo
        |Gosu
        |Grace
        |Gradle
        |Grammatical Framework
        |Graph Modeling Language
        |GraphQL
        |Graphviz (DOT)
        |Groovy
        |Groovy Server Pages
        |Hack
        |Haml
        |Handlebars
        |Harbour
        |Haskell
        |Haxe
        |HCL
        |HLSL
        |HTML
        |HTML+Django
        |HTML+ECR
        |HTML+EEX
        |HTML+ERB
        |HTML+PHP
        |HTTP
        |Hy
        |HyPhy
        |IDL
        |Idris
        |IGOR Pro
        |Inform 7
        |INI
        |Inno Setup
        |Io
        |Ioke
        |IRC log
        |Isabelle
        |Isabelle ROOT
        |J
        |Jasmin
        |Java
        |Java Server Pages
        |JavaScript
        |JFlex
        |Jison
        |Jison Lex
        |Jolie
        |JSON
        |JSON5
        |JSONiq
        |JSONLD
        |JSX
        |Julia
        |Jupyter Notebook
        |KiCad
        |Kit
        |Kotlin
        |KRL
        |LabVIEW
        |Lasso
        |Latte
        |Lean
        |Less
        |Lex
        |LFE
        |LilyPond
        |Limbo
        |Linker Script
        |Linux Kernel Module
        |Liquid
        |Literate Agda
        |Literate CoffeeScript
        |Literate Haskell
        |LiveScript
        |LLVM
        |Logos
        |Logtalk
        |LOLCODE
        |LookML
        |LoomScript
        |LSL
        |Lua
        |M
        |M4
        |M4Sugar
        |Makefile
        |Mako
        |Markdown
        |Marko
        |Mask
        |Mathematica
        |Matlab
        |Maven POM
        |Max
        |MAXScript
        |MediaWiki
        |Mercury
        |Meson
        |Metal
        |MiniD
        |Mirah
        |Modelica
        |Modula-2
        |Module Management System
        |Monkey
        |Moocode
        |MoonScript
        |MQL4
        |MQL5
        |MTML
        |MUF
        |mupad
        |Myghty
        |NCL
        |Nemerle
        |nesC
        |NetLinx
        |NetLinx+ERB
        |NetLogo
        |NewLisp
        |Nginx
        |Nim
        |Ninja
        |Nit
        |Nix
        |NL
        |NSIS
        |Nu
        |NumPy
        |ObjDump
        |Objective-C
        |Objective-C++
        |Objective-J
        |OCaml
        |Omgrofl
        |ooc
        |Opa
        |Opal
        |OpenCL
        |OpenEdge ABL
        |OpenRC runscript
        |OpenSCAD
        |OpenType Feature File
        |Org
        |Ox
        |Oxygene
        |Oz
        |P4
        |Pan
        |Papyrus
        |Parrot
        |Parrot Assembly
        |Parrot Internal Representation
        |Pascal
        |PAWN
        |Pep8
        |Perl
        |Perl6
        |PHP
        |Pic
        |Pickle
        |PicoLisp
        |PigLatin
        |Pike
        |PLpgSQL
        |PLSQL
        |Pod
        |PogoScript
        |Pony
        |PostScript
        |POV-Ray SDL
        |PowerBuilder
        |PowerShell
        |Processing
        |Prolog
        |Propeller Spin
        |Protocol Buffer
        |Public Key
        |Pug
        |Puppet
        |Pure Data
        |PureBasic
        |PureScript
        |Python
        |Python console
        |Python traceback
        |QMake
        |QML
        |R
        |Racket
        |Ragel
        |RAML
        |Rascal
        |Raw token data
        |RDoc
        |REALbasic
        |Reason
        |Rebol
        |Red
        |Redcode
        |Regular Expression
        |Ren'Py
        |RenderScript
        |reStructuredText
        |REXX
        |RHTML
        |RMarkdown
        |RobotFramework
        |Roff
        |Rouge
        |RPM Spec
        |Ruby
        |RUNOFF
        |Rust
        |Sage
        |SaltStack
        |SAS
        |Sass
        |Scala
        |Scaml
        |Scheme
        |Scilab
        |SCSS
        |Self
        |ShaderLab
        |Shell
        |ShellSession
        |Shen
        |Slash
        |Slim
        |Smali
        |Smalltalk
        |Smarty
        |SMT
        |SourcePawn
        |SPARQL
        |Spline Font Database
        |SQF
        |SQL
        |SQLPL
        |Squirrel
        |SRecode Template
        |Stan
        |Standard ML
        |Stata
        |STON
        |Stylus
        |Sublime Text Config
        |SubRip Text
        |SuperCollider
        |SVG
        |Swift
        |SystemVerilog
        |Tcl
        |Tcsh
        |Tea
        |Terra
        |TeX
        |Text
        |Textile
        |Thrift
        |TI Program
        |TLA
        |TOML
        |Turing
        |Turtle
        |Twig
        |TXL
        |TypeScript
        |Unified Parallel C
        |Unity3D Asset
        |Unix Assembly
        |Uno
        |UnrealScript
        |UrWeb
        |Vala
        |VCL
        |Verilog
        |VHDL
        |Vim script
        |Vim script
        |Visual Basic
        |Volt
        |Vue
        |Wavefront Material
        |Wavefront Object
        |Web Ontology Language
        |WebIDL
        |wisp
        |World of Warcraft Addon Data
        |X10
        |xBase
        |XC
        |XCompose
        |XML
        |Xojo
        |XPages
        |XProc
        |XQuery
        |XS
        |XSLT
        |Xtend
        |Yacc
        |YAML
        |YANG
        |Zephir
        |Zimpl
        |
        |451 languages
        |you can get only selected language list with '-l' option.
        |if languages is unknown, you can specify 'unkown'.
        |
      EOS
    end
end

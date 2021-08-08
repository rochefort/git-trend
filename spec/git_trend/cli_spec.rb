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
            |  1 Azure/azure-sdk-for-net                  C#            198
            |  2 microsoft/vscode                         TypeScript    277
            |  3 apache/pinot                             Java          192

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
            |No. Name                                       Lang         Star
            |--- ------------------------------------------ ---------- ------
            |  1 rails/rails                                Ruby           22
            |  2 fluent/fluentd                             Ruby           10
            |  3 heartcombo/devise                          Ruby            8
            |  4 rails/webpacker                            Ruby            4
            |  5 puppetlabs/puppet                          Ruby            8
            |  6 puma/puma                                  Ruby            7
            |  7 fastlane/fastlane                          Ruby           14
            |  8 mperham/sidekiq                            Ruby            7
            |  9 rubocop/rubocop                            Ruby            5
            | 10 gitlabhq/gitlabhq                          Ruby            9
            | 11 postalserver/postal                        Ruby           10
            | 12 faker-ruby/faker                           Ruby            5
            | 13 ruby/ruby                                  Ruby           13
            | 14 bblimke/webmock                            Ruby            1
            | 15 DataDog/dd-trace-rb                        Ruby            2
            | 16 github/linguist                            Ruby           14
            | 17 capistrano/capistrano                      Ruby            9
            | 18 Homebrew/linuxbrew-core                    Ruby            2
            | 19 activeadmin/activeadmin                    Ruby            2
            | 20 simplecov-ruby/simplecov                   Ruby            4
            | 21 zammad/zammad                              Ruby            4
            | 22 huginn/huginn                              Ruby           25
            | 23 activerecord-hackery/ransack               Ruby            2
            | 24 0x727/MetasploitModules_0x727              Ruby           40
            | 25 cryptopunksnotdead/programming-cryptopunks Ruby            9

          EOS
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end

      context "with alloy : when trending is nothing" do
        before { stub_request_get("trending/#{language}") }
        let(:language) { "alloy" }

        it "display the 0cases message" do
          res = <<-'EOS'.unindent
            |It looks like we don’t have any trending repositories.

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
            |No. Name                                       Lang         Star
            |--- ------------------------------------------ ---------- ------
            |  1 ruby/ruby                                  Ruby           47
            |  2 sorbet/sorbet                              Ruby          191
            |  3 hschne/rails-mini-profiler                 Ruby          109
            |  4 postalserver/postal                        Ruby           29
            |  5 elastic/elasticsearch-rails                Ruby            3
            |  6 DataDog/dd-trace-rb                        Ruby            4
            |  7 Homebrew/brew                              Ruby          130
            |  8 rails/webpacker                            Ruby            8
            |  9 github/explore                             Ruby           20
            | 10 rails/rails                                Ruby           68
            | 11 huginn/huginn                              Ruby           59
            | 12 Shopify/liquid                             Ruby           26
            | 13 dependabot/dependabot-core                 Ruby           25
            | 14 CanCanCommunity/cancancan                  Ruby           10
            | 15 thoughtbot/factory_bot                     Ruby           13
            | 16 jekyll/jekyll                              Ruby           66
            | 17 twbs/bootstrap-rubygem                     Ruby            3
            | 18 svenfuchs/rails-i18n                       Ruby            5
            | 19 rubygems/rubygems                          Ruby           15
            | 20 rapid7/metasploit-framework                Ruby           81
            | 21 puppetlabs/puppet                          Ruby           16
            | 22 faker-ruby/faker                           Ruby           12
            | 23 mastodon/mastodon                          Ruby           69
            | 24 opf/openproject                            Ruby           27
            | 25 cryptopunksnotdead/programming-cryptopunks Ruby           24

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
        |No. Name                                                   Lang         Star
        |--- ------------------------------------------------------ ---------- ------
        |  1 Azure/azure-sdk-for-net                                C#            198
        |  2 microsoft/vscode                                       TypeScript    277
        |  3 apache/pinot                                           Java          192
        |  4 tannerlinsley/react-query                              TypeScript    159
        |  5 datafuselabs/datafuse                                  Rust          354
        |  6 RPCS3/rpcs3                                            C++            99
        |  7 3b1b/manim                                             Python        360
        |  8 badtuxx/DescomplicandoDocker                                        1402
        |  9 badtuxx/DescomplicandoKubernetes                       Shell         240
        | 10 kubernetes/kompose                                     Go            170
        | 11 0voice/linux_kernel_wiki                                             180
        | 12 JetBrains/compose-jb                                   Kotlin        391
        | 13 alyssaxuu/mapus                                        JavaScript   1068
        | 14 prometheus/prometheus                                  Go            130
        | 15 mytechnotalent/Reverse-Engineering                     C             425
        | 16 testjavascript/nodejs-integration-tests-best-practices JavaScript    444
        | 17 metabase/metabase                                      Clojure       105
        | 18 Blinue/Magpie                                          HLSL          109
        | 19 dataease/dataease                                      Java          321
        | 20 mrousavy/react-native-vision-camera                    Swift         111
        | 21 geekxh/hello-algorithm                                 Java          259
        | 22 commaai/openpilot                                      C++          1172
        | 23 eugenp/tutorials                                       Java          136
        | 24 RasaHQ/rasa                                            Python        503
        | 25 zero205/JD_tencent_scf                                 JavaScript     45

      EOS
    end

    def dummy_result_no_options
      <<-'EOS'.unindent
        |No. Name                                                   Lang         Star Description                                                    
        |--- ------------------------------------------------------ ---------- ------ ---------------------------------------------------------------
        |  1 Azure/azure-sdk-for-net                                C#            198 This repository is for active development of the Azure SDK f...
        |  2 microsoft/vscode                                       TypeScript    277 Visual Studio Code                                             
        |  3 apache/pinot                                           Java          192 Apache Pinot (Incubating) - A realtime distributed OLAP data...
        |  4 tannerlinsley/react-query                              TypeScript    159 ⚛️ Hooks for fetching, caching and updating asynchronous data...
        |  5 datafuselabs/datafuse                                  Rust          354 A Modern Real-Time Data Processing & Analytics DBMS with Clo...
        |  6 RPCS3/rpcs3                                            C++            99 PS3 emulator/debugger                                          
        |  7 3b1b/manim                                             Python        360 Animation engine for explanatory math videos                   
        |  8 badtuxx/DescomplicandoDocker                                        1402 Descomplicando o Docker, o livro.                              
        |  9 badtuxx/DescomplicandoKubernetes                       Shell         240                                                                
        | 10 kubernetes/kompose                                     Go            170 Go from Docker Compose to Kubernetes                           
        | 11 0voice/linux_kernel_wiki                                             180 linux内核学习资料：200+经典内核文章，100+内核论文，50+内核项...
        | 12 JetBrains/compose-jb                                   Kotlin        391 Jetpack Compose for Desktop and Web, a modern UI framework f...
        | 13 alyssaxuu/mapus                                        JavaScript   1068 A map tool with real-time collaboration 🗺️                      
        | 14 prometheus/prometheus                                  Go            130 The Prometheus monitoring system and time series database.     
        | 15 mytechnotalent/Reverse-Engineering                     C             425 A FREE comprehensive reverse engineering course covering x86...
        | 16 testjavascript/nodejs-integration-tests-best-practices JavaScript    444 ✅ Master the art of the most powerful testing technique for...
        | 17 metabase/metabase                                      Clojure       105 The simplest, fastest way to get business intelligence and a...
        | 18 Blinue/Magpie                                          HLSL          109 使游戏窗口全屏显示                                             
        | 19 dataease/dataease                                      Java          321 人人可用的开源数据可视化分析工具。                             
        | 20 mrousavy/react-native-vision-camera                    Swift         111 📸 The Camera library that sees the vision.                    
        | 21 geekxh/hello-algorithm                                 Java          259 🌍 针对小白的算法训练 | 包括四部分：①.算法基础 ②.力扣图解 ③....
        | 22 commaai/openpilot                                      C++          1172 openpilot is an open source driver assistance system. openpi...
        | 23 eugenp/tutorials                                       Java          136 Just Announced - "Learn Spring Security OAuth":                
        | 24 RasaHQ/rasa                                            Python        503 💬 Open source machine learning framework to automate text- ...
        | 25 zero205/JD_tencent_scf                                 JavaScript     45 京东JS脚本，支持青龙、云函数、elecV2P。低调使用，请勿fork！... 

      EOS
    end

    def dummy_weekly_result
      <<-'EOS'.unindent
        |No. Name                                          Lang               Star
        |--- --------------------------------------------- ---------------- ------
        |  1 dataease/dataease                             Java               1272
        |  2 mitmproxy/mitmproxy                           Python              995
        |  3 commaai/openpilot                             C++                1859
        |  4 doocs/jvm                                     Java                573
        |  5 SJang1/korea-covid-19-remaining-vaccine-macro Python              357
        |  6 apple/swift-algorithms                        Swift               285
        |  7 ibraheemdev/modern-unix                                          1991
        |  8 freeCodeCamp/freeCodeCamp                     JavaScript         1460
        |  9 fuzhengwei/small-spring                       Java                491
        | 10 microsoft/Web-Dev-For-Beginners               JavaScript         2027
        | 11 geekxh/hello-algorithm                        Java                645
        | 12 deepmind/deepmind-research                    Jupyter Notebook    223
        | 13 clouDr-f2e/rubick                             JavaScript          604
        | 14 myspaghetti/macos-virtualbox                  Shell              1343
        | 15 Anuken/Mindustry                              Java                579
        | 16 JetBrains/compose-jb                          Kotlin              610
        | 17 google/googletest                             C++                 273
        | 18 kubernetes/kompose                            Go                  250
        | 19 golang-jwt/jwt                                Go                  139
        | 20 telegramdesktop/tdesktop                      C++                 362
        | 21 donnemartin/system-design-primer              Python             1132
        | 22 cloudreve/Cloudreve                           Go                  336
        | 23 discordjs/discord.js                          JavaScript          360
        | 24 github/docs                                   JavaScript          319
        | 25 sveltejs/kit                                  JavaScript          102

      EOS
    end

    def dummy_monthly_result
      <<-'EOS'.unindent
        |No. Name                                     Lang               Star
        |--- ---------------------------------------- ---------------- ------
        |  1 dromara/Sa-Token                         Java               1696
        |  2 dataease/dataease                        Java               1557
        |  3 myspaghetti/macos-virtualbox             Shell              2126
        |  4 bradtraversy/50projects50days            CSS                3098
        |  5 facebookresearch/ParlAI                  Python              851
        |  6 go-kratos/kratos                         Go                 1357
        |  7 ventoy/Ventoy                            C                  3896
        |  8 microsoft/ML-For-Beginners               Jupyter Notebook  10511
        |  9 mitmproxy/mitmproxy                      Python             1330
        | 10 geekxh/hello-algorithm                   Java                919
        | 11 microsoft/Web-Dev-For-Beginners          JavaScript         3645
        | 12 doocs/jvm                                Java                832
        | 13 org-roam/org-roam                        Emacs Lisp          259
        | 14 opensearch-project/OpenSearch            Java                866
        | 15 avelino/awesome-go                       Go                 1547
        | 16 outline/outline                          JavaScript          460
        | 17 supabase/supabase                        TypeScript         2409
        | 18 nvm-sh/nvm                               Shell               949
        | 19 smicallef/spiderfoot                     Python              328
        | 20 scutan90/DeepLearning-500-questions      JavaScript          494
        | 21 serverless-stack/serverless-stack        TypeScript          434
        | 22 deepmind/deepmind-research               Jupyter Notebook    493
        | 23 cabaletta/baritone                       Java                189
        | 24 flameshot-org/flameshot                  C++                 521
        | 25 trekhleb/javascript-algorithms           JavaScript         3655

      EOS
    end

    def dummy_languages
      <<-'EOS'.unindent
        |C++
        |HTML
        |Java
        |JavaScript
        |PHP
        |Python
        |Ruby
        |Unknown languages
        |1C Enterprise
        |4D
        |ABAP
        |ABAP CDS
        |ABNF
        |ActionScript
        |Ada
        |Adobe Font Metrics
        |Agda
        |AGS Script
        |AIDL
        |AL
        |AL
        |Alloy
        |Alpine Abuild
        |Altium Designer
        |AMPL
        |AngelScript
        |Ant Build System
        |ANTLR
        |ApacheConf
        |Apex
        |API Blueprint
        |APL
        |Apollo Guidance Computer
        |AppleScript
        |Arc
        |AsciiDoc
        |ASL
        |ASN.1
        |Classic ASP
        |ASP.NET
        |AspectJ
        |Assembly
        |Astro
        |Asymptote
        |ATS
        |Augeas
        |AutoHotkey
        |AutoIt
        |Avro IDL
        |Awk
        |Ballerina
        |BASIC
        |Batchfile
        |Beef
        |Befunge
        |BibTeX
        |Bicep
        |Bison
        |BitBake
        |Blade
        |BlitzBasic
        |BlitzMax
        |Bluespec
        |Boo
        |Boogie
        |Brainfuck
        |Brightscript
        |Zeek
        |Browserslist
        |C
        |C#
        |C-ObjDump
        |C2hs Haskell
        |Cabal Config
        |Cap'n Proto
        |CartoCSS
        |Ceylon
        |Chapel
        |Charity
        |ChucK
        |CIL
        |Cirru
        |Clarion
        |Classic ASP
        |Clean
        |Click
        |CLIPS
        |Clojure
        |Closure Templates
        |Cloud Firestore Security Rules
        |CMake
        |COBOL
        |CODEOWNERS
        |CodeQL
        |CoffeeScript
        |ColdFusion
        |ColdFusion CFC
        |COLLADA
        |Common Lisp
        |Common Workflow Language
        |Component Pascal
        |CoNLL-U
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
        |Cuda
        |CUE
        |cURL Config
        |CWeb
        |Cycript
        |Cython
        |D
        |D-ObjDump
        |Dafny
        |Darcs Patch
        |Dart
        |DataWeave
        |desktop
        |Dhall
        |Diff
        |DIGITAL Command Language
        |dircolors
        |DirectX 3D File
        |DM
        |DNS Zone
        |Dockerfile
        |Dogescript
        |DTrace
        |Dylan
        |E
        |Eagle
        |Easybuild
        |EBNF
        |eC
        |Ecere Projects
        |ECL
        |ECLiPSe
        |EditorConfig
        |Edje Data Collection
        |edn
        |Eiffel
        |EJS
        |Elixir
        |Elm
        |Emacs Lisp
        |EmberScript
        |E-mail
        |EQ
        |Erlang
        |F#
        |F*
        |Factor
        |Fancy
        |Fantom
        |Faust
        |Fennel
        |FIGlet Font
        |Filebench WML
        |Filterscript
        |fish
        |Fluent
        |FLUX
        |Formatted
        |Forth
        |Fortran
        |Fortran Free Form
        |FreeBasic
        |FreeMarker
        |Frege
        |Futhark
        |G-code
        |Game Maker Language
        |GAML
        |GAMS
        |GAP
        |GCC Machine Description
        |GDB
        |GDScript
        |GEDCOM
        |Genie
        |Genshi
        |Gentoo Ebuild
        |Gentoo Eclass
        |Gerber Image
        |Gettext Catalog
        |Gherkin
        |Git Attributes
        |Git Config
        |GLSL
        |Glyph
        |Glyph Bitmap Distribution Format
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
        |HAProxy
        |Harbour
        |Haskell
        |Haxe
        |HCL
        |HiveQL
        |HLSL
        |HolyC
        |Jinja
        |HTML+ECR
        |HTML+EEX
        |HTML+ERB
        |HTML+PHP
        |HTML+Razor
        |HTTP
        |HXML
        |Hy
        |HyPhy
        |IDL
        |Idris
        |Ignore List
        |IGOR Pro
        |ImageJ Macro
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
        |Java Properties
        |Java Server Pages
        |JavaScript+ERB
        |JFlex
        |Jinja
        |Jison
        |Jison Lex
        |Jolie
        |jq
        |JSON
        |JSON with Comments
        |JSON5
        |JSONiq
        |JSONLD
        |Jsonnet
        |Julia
        |Jupyter Notebook
        |Kaitai Struct
        |KakouneScript
        |KiCad Layout
        |KiCad Legacy Layout
        |KiCad Schematic
        |Kit
        |Kotlin
        |KRL
        |Kusto
        |LabVIEW
        |Lark
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
        |LTspice Symbol
        |Lua
        |M
        |M4
        |M4Sugar
        |Macaulay2
        |Makefile
        |Mako
        |Markdown
        |Marko
        |Mask
        |Mathematica
        |MATLAB
        |Maven POM
        |Max
        |MAXScript
        |mcfunction
        |Wikitext
        |Mercury
        |Meson
        |Metal
        |Microsoft Developer Studio Project
        |Microsoft Visual Studio Solution
        |MiniD
        |Mirah
        |mIRC Script
        |MLIR
        |Modelica
        |Modula-2
        |Modula-3
        |Module Management System
        |Monkey
        |Moocode
        |MoonScript
        |Motorola 68K Assembly
        |MQL4
        |MQL5
        |MTML
        |MUF
        |mupad
        |Muse
        |Mustache
        |Myghty
        |nanorc
        |NASL
        |NCL
        |Nearley
        |Nemerle
        |NEON
        |nesC
        |NetLinx
        |NetLinx+ERB
        |NetLogo
        |NewLisp
        |Nextflow
        |Nginx
        |Nim
        |Ninja
        |Nit
        |Nix
        |NL
        |NPM Config
        |NSIS
        |Nu
        |NumPy
        |Nunjucks
        |NWScript
        |ObjDump
        |Object Data Instance Notation
        |Objective-C
        |Objective-C++
        |Objective-J
        |ObjectScript
        |OCaml
        |Odin
        |Omgrofl
        |ooc
        |Opa
        |Opal
        |Open Policy Agent
        |OpenCL
        |OpenEdge ABL
        |OpenQASM
        |OpenRC runscript
        |OpenSCAD
        |OpenStep Property List
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
        |Pawn
        |PEG.js
        |Pep8
        |Perl
        |Pic
        |Pickle
        |PicoLisp
        |PigLatin
        |Pike
        |PlantUML
        |PLpgSQL
        |PLSQL
        |Pod
        |Pod 6
        |PogoScript
        |Pony
        |PostCSS
        |PostScript
        |POV-Ray SDL
        |PowerBuilder
        |PowerShell
        |Prisma
        |Processing
        |Proguard
        |Prolog
        |Propeller Spin
        |Protocol Buffer
        |Public Key
        |Pug
        |Puppet
        |Pure Data
        |PureBasic
        |PureScript
        |Python console
        |Python traceback
        |q
        |Q#
        |QMake
        |QML
        |Qt Script
        |Quake
        |R
        |Racket
        |Ragel
        |Raku
        |RAML
        |Rascal
        |Raw token data
        |RDoc
        |Readline Config
        |REALbasic
        |Reason
        |Rebol
        |Red
        |Redcode
        |Regular Expression
        |Ren'Py
        |RenderScript
        |ReScript
        |reStructuredText
        |REXX
        |Rich Text Format
        |Ring
        |Riot
        |RMarkdown
        |RobotFramework
        |robots.txt
        |Roff
        |Roff Manpage
        |Rouge
        |RPC
        |RPM Spec
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
        |sed
        |Self
        |ShaderLab
        |Shell
        |ShellSession
        |Shen
        |Sieve
        |Singularity
        |Slash
        |Slice
        |Slim
        |Smali
        |Smalltalk
        |Smarty
        |SmPL
        |SMT
        |Solidity
        |SourcePawn
        |SPARQL
        |Spline Font Database
        |SQF
        |SQL
        |SQLPL
        |Squirrel
        |SRecode Template
        |SSH Config
        |Stan
        |Standard ML
        |Starlark
        |Stata
        |STON
        |StringTemplate
        |Stylus
        |SubRip Text
        |SugarSS
        |SuperCollider
        |Svelte
        |SVG
        |Swift
        |SWIG
        |SystemVerilog
        |Tcl
        |Tcsh
        |Tea
        |Terra
        |TeX
        |Texinfo
        |Text
        |Textile
        |Thrift
        |TI Program
        |TLA
        |TOML
        |TSQL
        |TSV
        |TSX
        |Turing
        |Turtle
        |Twig
        |TXL
        |Type Language
        |TypeScript
        |Unified Parallel C
        |Unity3D Asset
        |Unix Assembly
        |Uno
        |UnrealScript
        |UrWeb
        |V
        |Vala
        |VBA
        |VBScript
        |VCL
        |Verilog
        |VHDL
        |Vim Help File
        |Vim script
        |Vim Snippet
        |Visual Basic .NET
        |Visual Basic .NET
        |Volt
        |Vue
        |Wavefront Material
        |Wavefront Object
        |wdl
        |Web Ontology Language
        |WebAssembly
        |WebIDL
        |WebVTT
        |Wget Config
        |Wikitext
        |Windows Registry Entries
        |wisp
        |Wollok
        |World of Warcraft Addon Data
        |X BitMap
        |X Font Directory Index
        |X PixMap
        |X10
        |xBase
        |XC
        |XCompose
        |XML
        |XML Property List
        |Xojo
        |Xonsh
        |XPages
        |XProc
        |XQuery
        |XS
        |XSLT
        |Xtend
        |Yacc
        |YAML
        |YANG
        |YARA
        |YASnippet
        |ZAP
        |Zeek
        |ZenScript
        |Zephir
        |Zig
        |ZIL
        |Zimpl
        |
        |603 languages
        |you can get only selected language list with '-l' option.
        |if languages is unknown, you can specify 'unkown'.
        |
      EOS
    end
end

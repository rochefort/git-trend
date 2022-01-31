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
            |  1 AppFlowy-IO/appflowy                     Rust          238
            |  2 iptv-org/iptv                            JavaScript    107
            |  3 nodejs/node                              JavaScript    123

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
            |No. Name                                          Lang         Star
            |--- --------------------------------------------- ---------- ------
            |  1 puppetlabs/puppet                             Ruby            6
            |  2 github/explore                                Ruby            5
            |  3 mastodon/mastodon                             Ruby            7
            |  4 forem/forem                                   Ruby            3
            |  5 Shopify/shopify-cli                           Ruby            2
            |  6 github/choosealicense.com                     Ruby            7
            |  7 sinatra/sinatra                               Ruby            1
            |  8 postalserver/postal                           Ruby            4
            |  9 chef/chef                                     Ruby            2
            | 10 mame/quine-relay                              Ruby            5
            | 11 rapid7/metasploit-framework                   Ruby            8
            | 12 freeCodeCamp/how-to-contribute-to-open-source Ruby            4
            | 13 freeCodeCamp/devdocs                          Ruby            8
            | 14 hashicorp/vagrant                             Ruby            6
            | 15 jekyll/jekyll                                 Ruby           12
            | 16 umd-cmsc330/cmsc330spring22                   Ruby            1
            | 17 gitlabhq/gitlabhq                             Ruby            1
            | 18 heartcombo/devise                             Ruby            2
            | 19 opf/openproject                               Ruby            4
            | 20 rails/rails                                   Ruby           23
            | 21 railwaycat/homebrew-emacsmacport              Ruby            1
            | 22 rubocop/rubocop                               Ruby            1
            | 23 thoughtbot/factory_bot                        Ruby            1
            | 24 fluent/fluentd                                Ruby            2
            | 25 spree/spree                                   Ruby            5

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
          res = <<-'EOS'.unindent
            |No. Name                                          Lang         Star
            |--- --------------------------------------------- ---------- ------
            |  1 huginn/huginn                                 Ruby          881
            |  2 faker-ruby/faker                              Ruby          193
            |  3 hashicorp/vagrant                             Ruby           46
            |  4 mperham/sidekiq                               Ruby           17
            |  5 freeCodeCamp/how-to-contribute-to-open-source Ruby           40
            |  6 rails/jsbundling-rails                        Ruby           20
            |  7 puma/puma                                     Ruby           10
            |  8 jekyll/jekyll                                 Ruby           72
            |  9 rails/rails                                   Ruby          103
            | 10 sinatra/sinatra                               Ruby           11
            | 11 rapid7/metasploit-framework                   Ruby           77
            | 12 puppetlabs/puppet                             Ruby           23
            | 13 Shopify/liquid                                Ruby           21
            | 14 github/linguist                               Ruby           27
            | 15 rmosolgo/graphql-ruby                         Ruby            2
            | 16 github/choosealicense.com                     Ruby           24
            | 17 fastlane/fastlane                             Ruby           96
            | 18 Homebrew/homebrew-core                        Ruby           28
            | 19 github/view_component                         Ruby           11
            | 20 hrishikesh1990/resume-builder                 Ruby            6
            | 21 varvet/pundit                                 Ruby            8
            | 22 github/explore                                Ruby           23
            | 23 heartcombo/devise                             Ruby           18
            | 24 activerecord-hackery/ransack                  Ruby           10
            | 25 Homebrew/homebrew-cask                        Ruby           32

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
        |No. Name                                         Lang         Star
        |--- -------------------------------------------- ---------- ------
        |  1 AppFlowy-IO/appflowy                         Rust          238
        |  2 iptv-org/iptv                                JavaScript    107
        |  3 nodejs/node                                  JavaScript    123
        |  4 yt-dlp/yt-dlp                                Python        139
        |  5 nextui-org/nextui                            TypeScript    515
        |  6 ciderapp/Cider                               JavaScript     58
        |  7 Ebazhanov/linkedin-skill-assessments-quizzes               266
        |  8 Jxck-S/plane-notify                          Python         39
        |  9 Koenkk/zigbee2mqtt                           JavaScript     77
        | 10 Developer-Y/cs-video-courses                               710
        | 11 HashLips/hashlips_art_engine                 JavaScript     93
        | 12 IBAX-io/go-ibax                              Go            775
        | 13 emilk/egui                                   Rust           34
        | 14 PathOfBuildingCommunity/PathOfBuilding       Lua            38
        | 15 uutils/coreutils                             Rust          269
        | 16 ryanoasis/nerd-fonts                         CSS            25
        | 17 KaLendsi/CVE-2022-21882                      C++            51
        | 18 kdrag0n/safetynet-fix                        C++            34
        | 19 Chia-Network/chia-blockchain                 Python         13
        | 20 github/docs                                  JavaScript     26
        | 21 RunaCapital/awesome-oss-alternatives         Python        415
        | 22 TheAlgorithms/Go                             Go            123
        | 23 pi-hole/docker-pi-hole                       Shell           5
        | 24 zhiwehu/Python-programming-exercises                        50
        | 25 LawnchairLauncher/lawnicons                  Kotlin          6

      EOS
    end

    def dummy_result_no_options
      <<-'EOS'.unindent
        |No. Name                                         Lang         Star Description
        |--- -------------------------------------------- ---------- ------ -------------------------------------------------------------------------
        |  1 AppFlowy-IO/appflowy                         Rust          238 AppFlowy is an open-source alternative to Notion. You are in charge of...
        |  2 iptv-org/iptv                                JavaScript    107 Collection of publicly available IPTV channels from all over the world
        |  3 nodejs/node                                  JavaScript    123 Node.js JavaScript runtime ✨🐢🚀✨
        |  4 yt-dlp/yt-dlp                                Python        139 A youtube-dl fork with additional features and fixes
        |  5 nextui-org/nextui                            TypeScript    515 🚀 Beautiful, fast and modern React UI library.
        |  6 ciderapp/Cider                               JavaScript     58 Project Cider. A new look into listening and enjoying Apple Music in s...
        |  7 Ebazhanov/linkedin-skill-assessments-quizzes               266 Full reference of LinkedIn answers 2022 for skill assessments, LinkedI...
        |  8 Jxck-S/plane-notify                          Python         39 Notify If a selected plane has taken off or landed using OpenSky or AD...
        |  9 Koenkk/zigbee2mqtt                           JavaScript     77 Zigbee 🐝 to MQTT bridge 🌉, get rid of your proprietary Zigbee bridge...
        | 10 Developer-Y/cs-video-courses                               710 List of Computer Science courses with video lectures.
        | 11 HashLips/hashlips_art_engine                 JavaScript     93 HashLips Art Engine is a tool used to create multiple different instan...
        | 12 IBAX-io/go-ibax                              Go            775 An innovative Blockchain Protocol Platform, which everyone can deploy ...
        | 13 emilk/egui                                   Rust           34 egui: an easy-to-use immediate mode GUI in Rust that runs on both web ...
        | 14 PathOfBuildingCommunity/PathOfBuilding       Lua            38 Offline build planner for Path of Exile.
        | 15 uutils/coreutils                             Rust          269 Cross-platform Rust rewrite of the GNU coreutils
        | 16 ryanoasis/nerd-fonts                         CSS            25 Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patch...
        | 17 KaLendsi/CVE-2022-21882                      C++            51 win32k LPE
        | 18 kdrag0n/safetynet-fix                        C++            34 Google SafetyNet attestation workarounds for Magisk
        | 19 Chia-Network/chia-blockchain                 Python         13 Chia blockchain python implementation (full node, farmer, harvester, t...
        | 20 github/docs                                  JavaScript     26 The open-source repo for docs.github.com
        | 21 RunaCapital/awesome-oss-alternatives         Python        415 Awesome list of open-source startup alternatives to well-known SaaS pr...
        | 22 TheAlgorithms/Go                             Go            123 Algorithms implemented in Go for beginners, following best practices.
        | 23 pi-hole/docker-pi-hole                       Shell           5 Pi-hole in a docker container
        | 24 zhiwehu/Python-programming-exercises                        50 100+ Python challenging programming exercises
        | 25 LawnchairLauncher/lawnicons                  Kotlin          6

      EOS
    end

    def dummy_weekly_result
      <<-'EOS'.unindent
        |No. Name                                         Lang         Star
        |--- -------------------------------------------- ---------- ------
        |  1 doocs/leetcode                               Java         1754
        |  2 veler/DevToys                                C#           2953
        |  3 Ebazhanov/linkedin-skill-assessments-quizzes               854
        |  4 papers-we-love/papers-we-love                Shell         825
        |  5 TheAlgorithms/Javascript                     JavaScript    425
        |  6 ciderapp/Cider                               JavaScript    247
        |  7 huginn/huginn                                Ruby          881
        |  8 public-apis/public-apis                      Python       1482
        |  9 akutz/go-generics-the-hard-way               Go            489
        | 10 pytorch/fairseq                              Python        292
        | 11 rancher-sandbox/rancher-desktop              TypeScript    478
        | 12 microsoft/playwright                         TypeScript   1085
        | 13 scikit-learn/scikit-learn                    Python        245
        | 14 DustinBrett/daedalOS                         JavaScript    991
        | 15 chiru-labs/ERC721A                           Solidity      226
        | 16 pedroslopez/whatsapp-web.js                  JavaScript    424
        | 17 abiosoft/colima                              Go            537
        | 18 jackfrued/Python-100-Days                    Python        503
        | 19 kedro-org/kedro                              Python        785
        | 20 khuedoan/homelab                             Python       1416
        | 21 imcuttle/mometa                              TypeScript    553
        | 22 nektos/act                                   Go            394
        | 23 spring-projects/spring-authorization-server  Java          165
        | 24 flameshot-org/flameshot                      C++           311
        | 25 yuzu-emu/yuzu                                C++           449

      EOS
    end

    def dummy_monthly_result
      <<-'EOS'.unindent
        |No. Name                                         Lang         Star
        |--- -------------------------------------------- ---------- ------
        |  1 Asabeneh/30-Days-Of-JavaScript               JavaScript   3736
        |  2 files-community/Files                        C#           3999
        |  3 adrianhajdin/project_web3.0                  JavaScript    994
        |  4 doocs/leetcode                               Java         2516
        |  5 tauri-apps/tauri                             Rust         4367
        |  6 HashLips/hashlips_art_engine                 JavaScript   1156
        |  7 bevyengine/bevy                              Rust         1389
        |  8 coqui-ai/TTS                                 Python        803
        |  9 apache/incubator-seatunnel                   Java         1136
        | 10 sunym1993/flash-linux0.11-talk               C            3237
        | 11 Textualize/rich                              Python       2676
        | 12 withastro/astro                              TypeScript   1467
        | 13 dgtlmoon/changedetection.io                  Python       1496
        | 14 safak/youtube                                CSS           377
        | 15 mattermost/focalboard                        TypeScript   2313
        | 16 Ebazhanov/linkedin-skill-assessments-quizzes              1458
        | 17 containers/podman                            Go            658
        | 18 TandoorRecipes/recipes                       HTML          601
        | 19 emilk/egui                                   Rust          967
        | 20 dataease/dataease                            Java          651
        | 21 danielyxie/bitburner                         JavaScript    776
        | 22 dwyl/english-words                           Python        422
        | 23 TheAlgorithms/Javascript                     JavaScript    839
        | 24 baidu/amis                                   TypeScript    765
        | 25 rancher-sandbox/rancher-desktop              TypeScript    746

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
        |E-mail
        |Eagle
        |Earthly
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
        |Gemfile.lock
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
        |Go Checksums
        |Go Module
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
        |Motoko
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
        |Promela
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
        |Valve Data Format
        |VBA
        |VBScript
        |VCL
        |Verilog
        |VHDL
        |Vim Help File
        |Vim Script
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
        |611 languages
        |you can get only selected language list with '-l' option.
        |if languages is unknown, you can specify 'unkown'.
        |
      EOS
    end
end

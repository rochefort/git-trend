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
            |  1 vmware/octant                            Go            162
            |  2 dengyuhan/magnetW                        Java          240
            |  3 sherlock-project/sherlock                Python         90

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
            |No. Name                                                  Lang         Star
            |--- ----------------------------------------------------- ---------- ------
            |  1 thepracticaldev/dev.to                                Ruby           41
            |  2 rails/rails                                           Ruby           15
            |  3 chef/chef                                             Ruby            4
            |  4 Netflix/fast_jsonapi                                  Ruby            4
            |  5 dependabot/dependabot-core                            Ruby            1
            |  6 guard/listen                                          Ruby            0
            |  7 braintree/runbook                                     Ruby           35
            |  8 solidusio/solidus                                     Ruby            0
            |  9 peatio/peatio                                         Ruby            1
            | 10 lynndylanhurley/devise_token_auth                     Ruby            0
            | 11 mperham/sidekiq                                       Ruby            3
            | 12 CocoaPods/CocoaPods                                   Ruby            0
            | 13 ruby/ruby                                             Ruby            8
            | 14 elastic/ansible-elasticsearch                         Ruby            0
            | 15 CocoaPods/Xcodeproj                                   Ruby            0
            | 16 spree/spree                                           Ruby            1
            | 17 brotandgames/ciao                                     Ruby           21
            | 18 dtan4/terraforming                                    Ruby            1
            | 19 elastic/logstash                                      Ruby            3
            | 20 plataformatec/simple_form                             Ruby            0
            | 21 jekyll/jekyll                                         Ruby           12
            | 22 rubocop-hq/rubocop                                    Ruby            4
            | 23 github-changelog-generator/github-changelog-generator Ruby            2
            | 24 sferik/rails_admin                                    Ruby            0
            | 25 rubysherpas/paranoia                                  Ruby            0

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
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 rapid7/metasploit-framework              Ruby           85
            |  2 jekyll/jekyll                            Ruby           72
            |  3 ruby/ruby                                Ruby           34
            |  4 greatghoul/remote-working                Ruby          113
            |  5 thepracticaldev/dev.to                   Ruby          109
            |  6 rails/rails                              Ruby           75
            |  7 fastlane/fastlane                        Ruby           66
            |  8 elastic/logstash                         Ruby           27
            |  9 zendesk/ruby-kafka                       Ruby            8
            | 10 activerecord-hackery/ransack             Ruby           17
            | 11 education/classroom                      Ruby           10
            | 12 faker-ruby/faker                         Ruby           21
            | 13 discourse/discourse                      Ruby           60
            | 14 DeathKing/Learning-SICP                  Ruby           40
            | 15 rails/webpacker                          Ruby           16
            | 16 bayandin/awesome-awesomeness             Ruby           48
            | 17 github/explore                           Ruby           18
            | 18 hashicorp/vagrant                        Ruby           42
            | 19 varvet/pundit                            Ruby           17
            | 20 ytti/oxidized                            Ruby           12
            | 21 thoughtbot/factory_bot                   Ruby            9
            | 22 dependabot/dependabot-core               Ruby           16
            | 23 spree/spree                              Ruby           15
            | 24 Homebrew/homebrew-core                   Ruby           34
            | 25 thibmaek/awesome-raspberry-pi            Ruby           53

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
        |No. Name                                                       Lang               Star
        |--- ---------------------------------------------------------- ---------------- ------
        |  1 vmware/octant                                              Go                  162
        |  2 dengyuhan/magnetW                                          Java                240
        |  3 sherlock-project/sherlock                                  Python               90
        |  4 amejiarosario/dsa.js-data-structures-algorithms-javascript JavaScript          188
        |  5 grafana/grafana                                            TypeScript           41
        |  6 Flaque/quirk                                               TypeScript           40
        |  7 2227324689/gpmall                                          Java                 51
        |  8 thepracticaldev/dev.to                                     Ruby                 41
        |  9 google/googletest                                          C++                  27
        | 10 NVIDIA/open-gpu-doc                                        C                   107
        | 11 Tencent/MedicalNet                                         Python               40
        | 12 didi/delta                                                 Python               72
        | 13 cnlh/nps                                                   Go                  190
        | 14 dennybritz/reinforcement-learning                          Jupyter Notebook     64
        | 15 remoteintech/remote-jobs                                   JavaScript           86
        | 16 jackfrued/Python-100-Days                                  Jupyter Notebook    182
        | 17 rabbitmq/rabbitmq-tutorials                                Java                 30
        | 18 istio/istio                                                Go                   18
        | 19 mozilla-mobile/fenix                                       Kotlin               10
        | 20 Igglybuff/awesome-piracy                                   HTML                 28
        | 21 fireeye/commando-vm                                        PowerShell           14
        | 22 arpitjindal97/technology_books                                                  58
        | 23 datawhalechina/leeml-notes                                                     301
        | 24 tlbootcamp/tlroadmap                                       Python               42
        | 25 facebook/create-react-app                                  JavaScript           58

      EOS
    end

    def dummy_result_no_options
      <<-'EOS'.unindent
        |No. Name                                                       Lang               Star Description                                          
        |--- ---------------------------------------------------------- ---------------- ------ -----------------------------------------------------
        |  1 vmware/octant                                              Go                  162 A web-based, highly extensible platform for develo...
        |  2 dengyuhan/magnetW                                          Java                240 磁力搜网页版 - 磁力链接聚合搜索 - https://bt.biedi...
        |  3 sherlock-project/sherlock                                  Python               90 🔎 Find usernames across social networks             
        |  4 amejiarosario/dsa.js-data-structures-algorithms-javascript JavaScript          188 Data Structures and Algorithms explained and imple...
        |  5 grafana/grafana                                            TypeScript           41 The tool for beautiful monitoring and metric analy...
        |  6 Flaque/quirk                                               TypeScript           40 ✨🐙 A GPL Licensed Cognitive Behavioral Therapy a...
        |  7 2227324689/gpmall                                          Java                 51 基于SpringBoot+Dubbo构建的电商平台-微服务架构        
        |  8 thepracticaldev/dev.to                                     Ruby                 41 Where programmers share ideas and help each other ...
        |  9 google/googletest                                          C++                  27 Googletest - Google Testing and Mocking Framework    
        | 10 NVIDIA/open-gpu-doc                                        C                   107 Documentation of NVIDIA chip/hardware interfaces     
        | 11 Tencent/MedicalNet                                         Python               40 Many studies have shown that the performance on de...
        | 12 didi/delta                                                 Python               72 DELTA is a deep learning based natural language an...
        | 13 cnlh/nps                                                   Go                  190 一款轻量级、功能强大的内网穿透代理服务器。支持tcp... 
        | 14 dennybritz/reinforcement-learning                          Jupyter Notebook     64 Implementation of Reinforcement Learning Algorithm...
        | 15 remoteintech/remote-jobs                                   JavaScript           86 A list of semi to fully remote-friendly companies ...
        | 16 jackfrued/Python-100-Days                                  Jupyter Notebook    182 Python - 100天从新手到大师                           
        | 17 rabbitmq/rabbitmq-tutorials                                Java                 30 Tutorials for using RabbitMQ in various ways         
        | 18 istio/istio                                                Go                   18 Connect, secure, control, and observe services.      
        | 19 mozilla-mobile/fenix                                       Kotlin               10                                                      
        | 20 Igglybuff/awesome-piracy                                   HTML                 28 A curated list of awesome warez and piracy links     
        | 21 fireeye/commando-vm                                        PowerShell           14 Complete Mandiant Offensive VM (Commando VM), a fu...
        | 22 arpitjindal97/technology_books                                                  58 Premium eBook free for Geeks                         
        | 23 datawhalechina/leeml-notes                                                     301 李宏毅《机器学习》笔记，在线阅读地址：https://data...
        | 24 tlbootcamp/tlroadmap                                       Python               42 👩🏼‍💻👨🏻‍💻Карта навыков и модель развития тимлидов 
        | 25 facebook/create-react-app                                  JavaScript           58 Set up a modern web app by running one command.      

      EOS
    end

    def dummy_weekly_result
      <<-'EOS'.unindent
        |No. Name                                                       Lang               Star
        |--- ---------------------------------------------------------- ---------------- ------
        |  1 0voice/interview_internal_reference                        Python               15
        |  2 chinese-poetry/chinese-poetry                              JavaScript            4
        |  3 peterq/pan-light                                           Go                    5
        |  4 sherlock-project/sherlock                                  Python                2
        |  5 facebook/hermes                                            C++                   4
        |  6 alipay/SoloPi                                              Java                  2
        |  7 lenve/vhr                                                  Java                  3
        |  8 jwasham/coding-interview-university                                              6
        |  9 qiurunze123/miaosha                                        Java                  2
        | 10 scutan90/DeepLearning-500-questions                                              4
        | 11 haotian-wang/google-access-helper                          JavaScript            1
        | 12 dianping/cat                                               Java                  1
        | 13 crmeb/CRMEB                                                JavaScript          642
        | 14 ardanlabs/gotraining                                       Go                  942
        | 15 lenve/VBlog                                                TSQL                  1
        | 16 zhaoolee/ChineseBQB                                        CSS                   2
        | 17 fastai/course-nlp                                          Jupyter Notebook    802
        | 18 aosabook/500lines                                          JavaScript          846
        | 19 alibaba/spring-cloud-alibaba                               Java                  1
        | 20 macrozheng/mall-learning                                   Java                798
        | 21 OpenFlutter/Flutter-Notebook                               Dart                  1
        | 22 huggingface/pytorch-transformers                           Python                2
        | 23 amejiarosario/dsa.js-data-structures-algorithms-javascript JavaScript            1

      EOS
    end

    def dummy_monthly_result
      <<-'EOS'.unindent
        |No. Name                                                       Lang               Star
        |--- ---------------------------------------------------------- ---------------- ------
        |  1 0voice/interview_internal_reference                        Python               15
        |  2 chinese-poetry/chinese-poetry                              JavaScript            4
        |  3 peterq/pan-light                                           Go                    5
        |  4 sherlock-project/sherlock                                  Python                2
        |  5 facebook/hermes                                            C++                   4
        |  6 alipay/SoloPi                                              Java                  2
        |  7 lenve/vhr                                                  Java                  3
        |  8 jwasham/coding-interview-university                                              6
        |  9 qiurunze123/miaosha                                        Java                  2
        | 10 scutan90/DeepLearning-500-questions                                              4
        | 11 haotian-wang/google-access-helper                          JavaScript            1
        | 12 dianping/cat                                               Java                  1
        | 13 crmeb/CRMEB                                                JavaScript          642
        | 14 ardanlabs/gotraining                                       Go                  942
        | 15 lenve/VBlog                                                TSQL                  1
        | 16 zhaoolee/ChineseBQB                                        CSS                   2
        | 17 fastai/course-nlp                                          Jupyter Notebook    802
        | 18 aosabook/500lines                                          JavaScript          846
        | 19 alibaba/spring-cloud-alibaba                               Java                  1
        | 20 macrozheng/mall-learning                                   Java                798
        | 21 OpenFlutter/Flutter-Notebook                               Dart                  1
        | 22 huggingface/pytorch-transformers                           Python                2
        | 23 amejiarosario/dsa.js-data-structures-algorithms-javascript JavaScript            1

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
        |ABAP
        |ABNF
        |ActionScript
        |Ada
        |Adobe Font Metrics
        |Agda
        |AGS Script
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
        |ASN.1
        |ASP
        |AspectJ
        |Assembly
        |Asymptote
        |ATS
        |Augeas
        |AutoHotkey
        |AutoIt
        |Awk
        |Ballerina
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
        |Zeek
        |C
        |C#
        |C++
        |C-ObjDump
        |C2hs Haskell
        |Cabal Config
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
        |Cloud Firestore Security Rules
        |CMake
        |COBOL
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
        |CWeb
        |Cycript
        |Cython
        |D
        |D-ObjDump
        |Darcs Patch
        |Dart
        |DataWeave
        |desktop
        |Dhall
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
        |Easybuild
        |EBNF
        |eC
        |Ecere Projects
        |ECL
        |ECLiPSe
        |Edje Data Collection
        |edn
        |Eiffel
        |EJS
        |Elixir
        |Elm
        |Emacs Lisp
        |EmberScript
        |EML
        |EQ
        |Erlang
        |F#
        |F*
        |Factor
        |Fancy
        |Fantom
        |FIGlet Font
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
        |HTML
        |HTML+Django
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
        |Java Properties
        |Java Server Pages
        |JavaScript
        |JavaScript+ERB
        |JFlex
        |Jison
        |Jison Lex
        |Jolie
        |JSON
        |JSON with Comments
        |JSON5
        |JSONiq
        |JSONLD
        |Jsonnet
        |JSX
        |Julia
        |Jupyter Notebook
        |KiCad Layout
        |KiCad Legacy Layout
        |KiCad Schematic
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
        |MATLAB
        |Maven POM
        |Max
        |MAXScript
        |mcfunction
        |MediaWiki
        |Mercury
        |Meson
        |Metal
        |MiniD
        |Mirah
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
        |Myghty
        |nanorc
        |NCL
        |Nearley
        |Nemerle
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
        |NSIS
        |Nu
        |NumPy
        |ObjDump
        |Objective-C
        |Objective-C++
        |Objective-J
        |ObjectScript
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
        |Pawn
        |Pep8
        |Perl
        |Perl 6
        |PHP
        |Pic
        |Pickle
        |PicoLisp
        |PigLatin
        |Pike
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
        |q
        |QMake
        |QML
        |Quake
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
        |Rich Text Format
        |Ring
        |RMarkdown
        |RobotFramework
        |Roff
        |Roff Manpage
        |Rouge
        |RPC
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
        |sed
        |Self
        |ShaderLab
        |Shell
        |ShellSession
        |Shen
        |Slash
        |Slice
        |Slim
        |Smali
        |Smalltalk
        |Smarty
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
        |Stata
        |STON
        |Stylus
        |SubRip Text
        |SugarSS
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
        |TSQL
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
        |Vala
        |VCL
        |Verilog
        |VHDL
        |Vim script
        |Visual Basic
        |Volt
        |Vue
        |Wavefront Material
        |Wavefront Object
        |wdl
        |Web Ontology Language
        |WebAssembly
        |WebIDL
        |WebVTT
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
        |524 languages
        |you can get only selected language list with '-l' option.
        |if languages is unknown, you can specify 'unkown'.
        |
      EOS
    end
end

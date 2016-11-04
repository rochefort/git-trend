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
            |  1 Bilibili/flv.js                          JavaScript   3782
            |  2 drathier/stack-overflow-import           Python        589
            |  3 FreeCodeCamp/FreeCodeCamp                JavaScript 191056

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
            |  1 webgradus/kms                            Ruby          115
            |  2 shakacode/react_on_rails                 Ruby         2111
            |  3 Homebrew/brew                            Ruby         4409
            |  4 rails/rails                              Ruby        33266
            |  5 jondot/awesome-react-native              Ruby         8260
            |  6 fastlane/fastlane                        Ruby        12056
            |  7 mitchellh/vagrant                        Ruby        13443
            |  8 discourse/discourse                      Ruby        19670
            |  9 jekyll/jekyll                            Ruby        27457
            | 10 caskroom/homebrew-cask                   Ruby         9882
            | 11 Thibaut/devdocs                          Ruby        10699
            | 12 rapid7/metasploit-framework              Ruby         6996
            | 13 CocoaPods/CocoaPods                      Ruby         8715
            | 14 rails-api/active_model_serializers       Ruby         3837
            | 15 kilimchoi/engineering-blogs              Ruby         8631
            | 16 plataformatec/devise                     Ruby        16116
            | 17 gettalong/hexapdf                        Ruby          300
            | 18 Gargron/mastodon                         Ruby          824
            | 19 mperham/sidekiq                          Ruby         6826
            | 20 bkeepers/dotenv                          Ruby         3691
            | 21 skywinder/github-changelog-generator     Ruby         2655
            | 22 gitlabhq/gitlabhq                        Ruby        18633
            | 23 Tim9Liu9/TimLiu-iOS                      Ruby         4830
            | 24 elastic/logstash                         Ruby         6637
            | 25 shakacode/react-webpack-rails-tutorial   Ruby         1118

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
            |  1 Homebrew/brew                            Ruby         4410
            |  2 fastlane/fastlane                        Ruby        12057
            |  3 jondot/awesome-react-native              Ruby         8262
            |  4 iberianpig/fusuma                        Ruby          129
            |  5 rails/rails                              Ruby        33266
            |  6 jekyll/jekyll                            Ruby        27459
            |  7 Gargron/mastodon                         Ruby          826
            |  8 gettalong/hexapdf                        Ruby          303
            |  9 Tim9Liu9/TimLiu-iOS                      Ruby         4830
            | 10 rapid7/metasploit-framework              Ruby         6996
            | 11 mitchellh/vagrant                        Ruby        13443
            | 12 discourse/discourse                      Ruby        19671
            | 13 cookpad/kuroko2                          Ruby           85
            | 14 shakacode/react_on_rails                 Ruby         2114
            | 15 caskroom/homebrew-cask                   Ruby         9883
            | 16 Thibaut/devdocs                          Ruby        10699
            | 17 plataformatec/devise                     Ruby        16116
            | 18 ruby/ruby                                Ruby        10880
            | 19 sass/sass                                Ruby         8825
            | 20 logstash-plugins/logstash-patterns-core  Ruby          420
            | 21 webgradus/kms                            Ruby          117
            | 22 CocoaPods/CocoaPods                      Ruby         8715
            | 23 Homebrew/homebrew-core                   Ruby          979
            | 24 cantino/huginn                           Ruby        15035
            | 25 twbs/bootstrap-sass                      Ruby        11486

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
      |No. Name                                     Lang          Star
      |--- ---------------------------------------- ----------- ------
      |  1 Bilibili/flv.js                          JavaScript    3782
      |  2 drathier/stack-overflow-import           Python         589
      |  3 FreeCodeCamp/FreeCodeCamp                JavaScript  191056
      |  4 alexjc/neural-enhance                    Python        4380
      |  5 mzabriskie/axios                         JavaScript    7565
      |  6 airbnb/knowledge-repo                    Python         621
      |  7 skatejs/skatejs                          JavaScript    1482
      |  8 UFreedom/FloatingView                    Java           304
      |  9 verekia/js-stack-from-scratch            JavaScript    7684
      | 10 portainer/portainer                      JavaScript     463
      | 11 CISOfy/lynis                             Shell         1480
      | 12 vuejs/vue                                JavaScript   32676
      | 13 th0r/webpack-bundle-analyzer             JavaScript    1438
      | 14 thunderrise/android-TNRAnimationHelper   Java           487
      | 15 Jasonette/JASONETTE-iOS                  Objective-C    164
      | 16 justjavac/awesome-wechat-weapp           JavaScript    3859
      | 17 yarnpkg/yarn                             JavaScript   18470
      | 18 jwasham/google-interview-university                   19524
      | 19 lengstrom/fast-style-transfer            Python        1654
      | 20 FreeCodeCampChina/freecodecamp.cn        CSS           3016
      | 21 minoca/os                                C             1616
      | 22 facebook/react                           JavaScript   53230
      | 23 sqreen/awesome-nodejs-projects                         1454
      | 24 tensorflow/tensorflow                    C++          36152
      | 25 andyxialm/TyperEditText                  Java           110

    EOS
  end

  def dummy_result_no_options
    <<-'EOS'.unindent
      |No. Name                                     Lang          Star Description                                                                 
      |--- ---------------------------------------- ----------- ------ ----------------------------------------------------------------------------
      |  1 Bilibili/flv.js                          JavaScript    3782 HTML5 FLV Player                                                            
      |  2 drathier/stack-overflow-import           Python         589 Import arbitrary code from Stack Overflow as Python modules.                
      |  3 FreeCodeCamp/FreeCodeCamp                JavaScript  191056 The https://FreeCodeCamp.com open source codebase and curriculum. Learn t...
      |  4 alexjc/neural-enhance                    Python        4380 Super Resolution for images using deep learning.                            
      |  5 mzabriskie/axios                         JavaScript    7565 Promise based HTTP client for the browser and node.js                       
      |  6 airbnb/knowledge-repo                    Python         621 A next-generation curated knowledge sharing platform for data scientists ...
      |  7 skatejs/skatejs                          JavaScript    1482 SkateJS is a web component library designed to give you an augmentation o...
      |  8 UFreedom/FloatingView                    Java           304 FloatingView can make the target view floating above the anchor view with...
      |  9 verekia/js-stack-from-scratch            JavaScript    7684 Step-by-step tutorial to build a modern JavaScript stack from scratch       
      | 10 portainer/portainer                      JavaScript     463 Simple management UI for Docker                                             
      | 11 CISOfy/lynis                             Shell         1480 Lynis - Security auditing tool for Linux, macOS, and UNIX-based systems. ...
      | 12 vuejs/vue                                JavaScript   32676 Simple yet powerful library for building modern web interfaces.             
      | 13 th0r/webpack-bundle-analyzer             JavaScript    1438 Webpack plugin and CLI utility that represents bundle content as convenie...
      | 14 thunderrise/android-TNRAnimationHelper   Java           487 This is a library that contains practical animations: Rotation, Flip, Hor...
      | 15 Jasonette/JASONETTE-iOS                  Objective-C    164 📡 Native App over HTTP                                                     
      | 16 justjavac/awesome-wechat-weapp           JavaScript    3859 微信小程序开发资源汇总 wechat weapp                                         
      | 17 yarnpkg/yarn                             JavaScript   18470 📦🐈 Fast, reliable, and secure dependency management.                      
      | 18 jwasham/google-interview-university                   19524 A complete daily plan for studying to become a Google software engineer.    
      | 19 lengstrom/fast-style-transfer            Python        1654 Fast Style Transfer in TensorFlow                                           
      | 20 FreeCodeCampChina/freecodecamp.cn        CSS           3016 看源码请到Code，提问请到Issues，提交代码请到Pull requests，看学习心得请到...
      | 21 minoca/os                                C             1616 Minoca operating system                                                     
      | 22 facebook/react                           JavaScript   53230 A declarative, efficient, and flexible JavaScript library for building us...
      | 23 sqreen/awesome-nodejs-projects                         1454 Curated list of awesome open-source applications made with Node.js          
      | 24 tensorflow/tensorflow                    C++          36152 Computation using data flow graphs for scalable machine learning            
      | 25 andyxialm/TyperEditText                  Java           110 Typewriter                                                                  

    EOS
  end

  def dummy_weekly_result
    <<-'EOS'.unindent
      |No. Name                                           Lang         Star
      |--- ---------------------------------------------- ---------- ------
      |  1 verekia/js-stack-from-scratch                  JavaScript   7704
      |  2 alexjc/neural-enhance                          Python       4401
      |  3 FreeCodeCamp/FreeCodeCamp                      JavaScript 191088
      |  4 witheve/Eve                                    JavaScript   4896
      |  5 Bilibili/flv.js                                JavaScript   3796
      |  6 lengstrom/fast-style-transfer                  Python       1663
      |  7 VoLuong/Begin-Latex-in-minutes                              1652
      |  8 minoca/os                                      C            1622
      |  9 sqreen/awesome-nodejs-projects                              1455
      | 10 th0r/webpack-bundle-analyzer                   JavaScript   1446
      | 11 blue-yonder/tsfresh                            Python       1419
      | 12 zeit/next.js                                   JavaScript   5191
      | 13 GoogleChrome/lighthouse                        JavaScript   3962
      | 14 jwasham/google-interview-university                        19533
      | 15 mas-cli/mas                                    Swift        2261
      | 16 mattrajca/sudo-touchid                         C             884
      | 17 songrotek/Deep-Learning-Papers-Reading-Roadmap Python       7241
      | 18 yarnpkg/yarn                                   JavaScript  18477
      | 19 ImmortalZ/TransitionHelper                     Java          790
      | 20 the-control-group/voyager                      PHP           818
      | 21 vuejs/vue                                      JavaScript  32693
      | 22 jobbole/awesome-programming-books                            821
      | 23 tensorflow/tensorflow                          C++         36159
      | 24 BelooS/ChipsLayoutManager                      Java          714
      | 25 krisk/Fuse                                     JavaScript   3369

    EOS
  end

  def dummy_monthly_result
    <<-'EOS'.unindent
      |No. Name                                           Lang         Star
      |--- ---------------------------------------------- ---------- ------
      |  1 verekia/js-stack-from-scratch                  JavaScript   7704
      |  2 alexjc/neural-enhance                          Python       4401
      |  3 FreeCodeCamp/FreeCodeCamp                      JavaScript 191088
      |  4 witheve/Eve                                    JavaScript   4896
      |  5 Bilibili/flv.js                                JavaScript   3796
      |  6 lengstrom/fast-style-transfer                  Python       1663
      |  7 VoLuong/Begin-Latex-in-minutes                              1652
      |  8 minoca/os                                      C            1622
      |  9 sqreen/awesome-nodejs-projects                              1455
      | 10 th0r/webpack-bundle-analyzer                   JavaScript   1446
      | 11 blue-yonder/tsfresh                            Python       1419
      | 12 zeit/next.js                                   JavaScript   5191
      | 13 GoogleChrome/lighthouse                        JavaScript   3962
      | 14 jwasham/google-interview-university                        19533
      | 15 mas-cli/mas                                    Swift        2261
      | 16 mattrajca/sudo-touchid                         C             884
      | 17 songrotek/Deep-Learning-Papers-Reading-Roadmap Python       7241
      | 18 yarnpkg/yarn                                   JavaScript  18477
      | 19 ImmortalZ/TransitionHelper                     Java          790
      | 20 the-control-group/voyager                      PHP           818
      | 21 vuejs/vue                                      JavaScript  32693
      | 22 jobbole/awesome-programming-books                            821
      | 23 tensorflow/tensorflow                          C++         36159
      | 24 BelooS/ChipsLayoutManager                      Java          714
      | 25 krisk/Fuse                                     JavaScript   3369

    EOS
  end

  def dummy_languages
    <<-'EOS'.unindent
      |1C Enterprise
      |ABAP
      |ActionScript
      |Ada
      |Agda
      |AGS Script
      |Alloy
      |AMPL
      |ANTLR
      |ApacheConf
      |Apex
      |API Blueprint
      |APL
      |AppleScript
      |Arc
      |Arduino
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
      |CMake
      |COBOL
      |CoffeeScript
      |ColdFusion
      |Common Lisp
      |Component Pascal
      |Cool
      |Coq
      |Crystal
      |Csound
      |Csound Document
      |Csound Score
      |CSS
      |Cucumber
      |Cuda
      |Cycript
      |D
      |Darcs Patch
      |Dart
      |Diff
      |DIGITAL Command Language
      |DM
      |Dogescript
      |DTrace
      |Dylan
      |E
      |Eagle
      |eC
      |ECL
      |Eiffel
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
      |FLUX
      |Forth
      |FORTRAN
      |FreeMarker
      |Frege
      |Game Maker Language
      |GAMS
      |GAP
      |GCC Machine Description
      |GDB
      |GDScript
      |Genshi
      |Gettext Catalog
      |GLSL
      |Glyph
      |Gnuplot
      |Go
      |Golo
      |Gosu
      |Grace
      |Grammatical Framework
      |Groff
      |Groovy
      |Hack
      |Handlebars
      |Harbour
      |Haskell
      |Haxe
      |HCL
      |HLSL
      |HTML
      |Hy
      |HyPhy
      |IDL
      |Idris
      |IGOR Pro
      |Inform 7
      |Inno Setup
      |Io
      |Ioke
      |Isabelle
      |J
      |Jasmin
      |Java
      |JavaScript
      |JFlex
      |JSONiq
      |Julia
      |Jupyter Notebook
      |KiCad
      |Kit
      |Kotlin
      |KRL
      |LabVIEW
      |Lasso
      |Lean
      |Lex
      |LilyPond
      |Limbo
      |Liquid
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
      |Makefile
      |Mako
      |Markdown
      |Mask
      |Mathematica
      |Matlab
      |Max
      |MAXScript
      |Mercury
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
      |Nimrod
      |Nit
      |Nix
      |NSIS
      |Nu
      |Objective-C
      |Objective-C++
      |Objective-J
      |OCaml
      |Omgrofl
      |ooc
      |Opa
      |Opal
      |OpenEdge ABL
      |OpenSCAD
      |Ox
      |Oxygene
      |Oz
      |Pan
      |Papyrus
      |Parrot
      |Pascal
      |PAWN
      |Perl
      |Perl6
      |PHP
      |PicoLisp
      |PigLatin
      |Pike
      |PLpgSQL
      |PLSQL
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
      |Puppet
      |Pure Data
      |PureBasic
      |PureScript
      |Python
      |QMake
      |QML
      |R
      |Racket
      |Ragel in Ruby Host
      |RAML
      |RDoc
      |REALbasic
      |Rebol
      |Red
      |Redcode
      |Ren'Py
      |RenderScript
      |REXX
      |RobotFramework
      |Rouge
      |Ruby
      |RUNOFF
      |Rust
      |SaltStack
      |SAS
      |Scala
      |Scheme
      |Scilab
      |Self
      |Shell
      |ShellSession
      |Shen
      |Slash
      |Smali
      |Smalltalk
      |Smarty
      |SMT
      |SourcePawn
      |SQF
      |SQL
      |SQLPL
      |Squirrel
      |SRecode Template
      |Stan
      |Standard ML
      |Stata
      |SuperCollider
      |Swift
      |SystemVerilog
      |Tcl
      |Tea
      |Terra
      |TeX
      |Thrift
      |TI Program
      |TLA
      |Turing
      |TXL
      |TypeScript
      |Uno
      |UnrealScript
      |UrWeb
      |Vala
      |VCL
      |Verilog
      |VHDL
      |VimL
      |Visual Basic
      |Volt
      |Vue
      |Web Ontology Language
      |WebIDL
      |wisp
      |X10
      |xBase
      |XC
      |XML
      |Xojo
      |XPages
      |XProc
      |XQuery
      |XS
      |XSLT
      |Xtend
      |Yacc
      |Zephir
      |Zimpl
      |
      |322 languages
      |you can get only selected language list with '-l' option.
      |if languages is unknown, you can specify 'unkown'.
      |
    EOS
  end
end

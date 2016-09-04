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

  describe '#list' do
    let(:cli) { CLI.new }

    describe "with -n option" do
      context "with 3" do
        before { stub_request_get("trending") }
        let(:number) { 3 }
        it "display top 3 daily ranking" do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 HunterLarco/voxel.css                    CSS           941
            |  2 fengyuanchen/viewerjs                    JavaScript    716
            |  3 FreeCodeCamp/FreeCodeCamp                JavaScript    614

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
        before { stub_request_get("trending?l=#{language}") }
        let(:language) { "ruby" }

        it "display daily ranking by language" do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 rails/rails                              Ruby           24
            |  2 thoughtbot/scenic                        Ruby           34
            |  3 Homebrew/homebrew                        Ruby           26
            |  4 jekyll/jekyll                            Ruby           23
            |  5 Thibaut/devdocs                          Ruby           19
            |  6 jondot/awesome-react-native              Ruby           16
            |  7 fastlane/fastlane                        Ruby           15
            |  8 discourse/discourse                      Ruby           13
            |  9 mitchellh/vagrant                        Ruby           13
            | 10 caskroom/homebrew-cask                   Ruby           11
            | 11 shakacode/react_on_rails                 Ruby           14
            | 12 gitlabhq/gitlabhq                        Ruby           13
            | 13 samaaron/sonic-pi                        Ruby           12
            | 14 ruby/ruby                                Ruby           10
            | 15 twbs/bootstrap-sass                      Ruby           11
            | 16 rapid7/metasploit-framework              Ruby            8
            | 17 tmuxinator/tmuxinator                    Ruby           10
            | 18 CocoaPods/CocoaPods                      Ruby            9
            | 19 plataformatec/devise                     Ruby            9
            | 20 saasbook/typo                            Ruby            0
            | 21 bbatsov/rubocop                          Ruby            7
            | 22 Shopify/liquid                           Ruby            8
            | 23 thoughtbot/administrate                  Ruby            7
            | 24 capistrano/capistrano                    Ruby            7
            | 25 brandonhilkert/sucker_punch              Ruby            7

          EOS
          expect { cli.invoke(:list, [], language: language, description: false) }.to output(res).to_stdout
        end
      end

      context "with objective-c++ (including + sign)" do
        before { stub_request_get("trending?l=objective-c%2B%2B") }
        let(:language) { "objective-c++" }

        it "display daily ranking by language" do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang            Star
            |--- ---------------------------------------- ------------- ------
            |  1 facebook/pop                             Objective-C++      0
            |  2 facebook/componentkit                    Objective-C++      0
            |  3 rsms/fb-mac-messenger                    Objective-C++      0
            |  4 johnno1962/Xtrace                        Objective-C++      0
            |  5 pivotal/cedar                            Objective-C++      0
            |  6 rogual/neovim-dot-app                    Objective-C++      0
            |  7 mousebird/WhirlyGlobe                    Objective-C++      0
            |  8 deanm/plask                              Objective-C++      0
            |  9 jerols/PopTut                            Objective-C++      0
            | 10 fjolnir/Tranquil                         Objective-C++      0
            | 11 otaviocc/OCBorghettiView                 Objective-C++      0
            | 12 jxd001/POPdemo                           Objective-C++      0
            | 13 foundry/OpenCVSwiftStitch                Objective-C++      0
            | 14 couchdeveloper/RXPromise                 Objective-C++      0
            | 15 petegoodliffe/PGMidi                     Objective-C++      0
            | 16 opensource-apple/objc4                   Objective-C++      0
            | 17 giladno/UICoreTextView                   Objective-C++      0
            | 18 iolate/SimulateTouch                     Objective-C++      0
            | 19 otaviocc/NHCalendarActivity              Objective-C++      0
            | 20 belkevich/nsdate-calendar                Objective-C++      0
            | 21 pivotal/PivotalCoreKit                   Objective-C++      0
            | 22 openpeer/opios                           Objective-C++      0
            | 23 swift2js/swift2js                        Objective-C++      0
            | 24 Smartype/iOS_VPNPlugIn                   Objective-C++      0
            | 25 ryanb93/Applefy                          Objective-C++      0

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
          ENV["COLUMNS"] = "84" # it is not enough for description.
          ENV["LINES"] = "40"
        end

        it "display daily ranking about the same as no option" do
          expect { cli.invoke(:list, [], description: true) }.to output(dummy_result_without_description).to_stdout
        end
      end
    end

    describe "with -l and -s option" do
      context "with ruby and weekly" do
        before { stub_request_get("trending?l=#{language}&since=#{since}") }
        let(:language) { "ruby" }
        let(:since) { "weekly" }

        it "display weekly ranking by language" do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 Homebrew/homebrew                        Ruby          166
            |  2 shakacode/react_on_rails                 Ruby          197
            |  3 rails/rails                              Ruby          144
            |  4 jekyll/jekyll                            Ruby          136
            |  5 powerpak/tqdm-ruby                       Ruby          149
            |  6 fastlane/fastlane                        Ruby          117
            |  7 codekitchen/dinghy                       Ruby          116
            |  8 discourse/discourse                      Ruby           98
            |  9 jondot/awesome-react-native              Ruby           97
            | 10 hanami/hanami                            Ruby           96
            | 11 kciter/simple-slack-bot                  Ruby           95
            | 12 zverok/worldize                          Ruby           95
            | 13 mitchellh/vagrant                        Ruby           80
            | 14 Thibaut/devdocs                          Ruby           82
            | 15 plataformatec/devise                     Ruby           69
            | 16 caskroom/homebrew-cask                   Ruby           54
            | 17 gitlabhq/gitlabhq                        Ruby           60
            | 18 ruby/ruby                                Ruby           58
            | 19 jeremyevans/sequel                       Ruby           67
            | 20 schneems/derailed_benchmarks             Ruby           63
            | 21 thoughtbot/scenic                        Ruby           62
            | 22 cantino/huginn                           Ruby           57
            | 23 sass/sass                                Ruby           53
            | 24 kilimchoi/engineering-blogs              Ruby           53
            | 25 thoughtbot/administrate                  Ruby           48

          EOS
          expect { cli.invoke(:list, [], language: language, since: since, description: false) }.to output(res).to_stdout
        end
      end
    end

    describe "without options" do
      context "with multibyte chracters" do
        before do
          ENV["COLUMNS"] = "140"
          ENV["LINES"] = "40"
          stub_request_get("trending", "trending_including_multibyte_characters")
        end
        it "display daily ranking" do
          expect { cli.invoke(:list, []) }.to output(dummy_result_no_options_with_multibyte_characters).to_stdout
        end
      end
    end
  end

  describe '#languages' do
    before { stub_request_get("trending") }
    let(:cli) { CLI.new }

    context "with no option" do
      it "display languages" do
        expect { cli.languages }.to output(dummy_languages).to_stdout
      end
    end
  end

  private

  def stub_request_get(stub_url, stub_file_name = nil)
    url = Scraper::BASE_HOST.dup
    url << "/#{stub_url}" if stub_url
    uri = URI.parse(url)
    stub_file = stub_file_name || stub_url
    stub_request(:get, uri)
      .to_return(
        status: 200,
        headers: { content_type: "text/html" },
        body: load_http_stub(stub_file))
  end

  def dummy_result_without_description
    <<-'EOS'.unindent
      |No. Name                                     Lang           Star
      |--- ---------------------------------------- ------------ ------
      |  1 HunterLarco/voxel.css                    CSS             941
      |  2 fengyuanchen/viewerjs                    JavaScript      716
      |  3 FreeCodeCamp/FreeCodeCamp                JavaScript      614
      |  4 Microsoft/CNTK                           C++             378
      |  5 cht8687/You-Dont-Need-Lodash-Underscore  JavaScript      333
      |  6 jgthms/bulma                             CSS             334
      |  7 developit/preact                         JavaScript      322
      |  8 twitterdev/furni-ios                     Swift           303
      |  9 DrkSephy/es6-cheatsheet                  JavaScript      278
      | 10 chinchang/hint.css                       CSS             242
      | 11 denysdovhan/bash-handbook                JavaScript      201
      | 12 yabwe/medium-editor                      JavaScript      192
      | 13 nlf/dlite                                Go              187
      | 14 hollance/swift-algorithm-club            Swift           173
      | 15 jiahaog/nativefier                       JavaScript      163
      | 16 mxstbr/login-flow                        JavaScript      159
      | 17 Soundnode/soundnode-app                  JavaScript      146
      | 18 hirak/prestissimo                        PHP             149
      | 19 txusballesteros/sliding-deck             Java            140
      | 20 tensorflow/tensorflow                    C++              86
      | 21 milligram/milligram                      CSS             113
      | 22 valentin012/conspeech                    OpenEdge ABL    108
      | 23 gophergala2016/goad                      CSS             108
      | 24 Yalantis/uCrop                           Java            103
      | 25 mpociot/whiteboard                       JavaScript       97

    EOS
  end

  def dummy_result_no_options
    <<-'EOS'.unindent
      |No. Name                                     Lang           Star Description                                                                
      |--- ---------------------------------------- ------------ ------ ---------------------------------------------------------------------------
      |  1 HunterLarco/voxel.css                    CSS             941 A lightweight 3D CSS voxel library.                                        
      |  2 fengyuanchen/viewerjs                    JavaScript      716 JavaScript image viewer.                                                   
      |  3 FreeCodeCamp/FreeCodeCamp                JavaScript      614 The http://FreeCodeCamp.com open source codebase and curriculum. Learn t...
      |  4 Microsoft/CNTK                           C++             378 Computational Network Toolkit (CNTK)                                       
      |  5 cht8687/You-Dont-Need-Lodash-Underscore  JavaScript      333 Lists of Javascript methods which you can use natively                     
      |  6 jgthms/bulma                             CSS             334 Modern CSS framework based on Flexbox                                      
      |  7 developit/preact                         JavaScript      322 Fast 3kb React alternative with the same ES6 API. Components & Virtual DOM.
      |  8 twitterdev/furni-ios                     Swift           303 Furni for iOS is a furniture store demo app presented at the Twitter Fli...
      |  9 DrkSephy/es6-cheatsheet                  JavaScript      278 ES2015 [ES6] cheatsheet containing tips, tricks, best practices and code...
      | 10 chinchang/hint.css                       CSS             242 A CSS only tooltip library for your lovely websites.                       
      | 11 denysdovhan/bash-handbook                JavaScript      201 For those who wanna learn Bash                                             
      | 12 yabwe/medium-editor                      JavaScript      192 Medium.com WYSIWYG editor clone. Uses contenteditable API to implement a...
      | 13 nlf/dlite                                Go              187 The simplest way to use Docker on OS X                                     
      | 14 hollance/swift-algorithm-club            Swift           173 Algorithms and data structures in Swift, with explanations!                
      | 15 jiahaog/nativefier                       JavaScript      163 Wrap any web page natively without even thinking, across Windows, OSX an...
      | 16 mxstbr/login-flow                        JavaScript      159 A login/register flow built with React&Redux                               
      | 17 Soundnode/soundnode-app                  JavaScript      146 Soundnode App is the Soundcloud for desktop. Built with NW.js, Angular.j...
      | 18 hirak/prestissimo                        PHP             149 composer parallel install plugin                                           
      | 19 txusballesteros/sliding-deck             Java            140 SlidingDeck View for Android                                               
      | 20 tensorflow/tensorflow                    C++              86 Computation using data flow graphs for scalable machine learning           
      | 21 milligram/milligram                      CSS             113 A minimalist CSS framework.                                                
      | 22 valentin012/conspeech                    OpenEdge ABL    108 Political Speech Generator                                                 
      | 23 gophergala2016/goad                      CSS             108 Goad is an AWS Lambda powered, highly distributed, load testing tool       
      | 24 Yalantis/uCrop                           Java            103 Image Cropping Library for Android                                         
      | 25 mpociot/whiteboard                       JavaScript       97 Simply write beautiful API documentation.                                  

    EOS
  end

  def dummy_result_no_options_with_multibyte_characters
    <<-'EOS'.unindent
      |No. Name                                     Lang         Star Description                                                                  
      |--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
      |  1 apple/swift                              C++          1487 The Swift Programming Language                                               
      |  2 hashcat/hashcat                          C             383 Advanced CPU-based password recovery utility                                 
      |  3 airbnb/reagent                           JavaScript    416 JavaScript Testing utilities for React                                       
      |  4 FreeCodeCamp/FreeCodeCamp                JavaScript    381 The http://FreeCodeCamp.com open source codebase and curriculum. Learn to ...
      |  5 diafygi/acme-tiny                        Python        311 A tiny script to issue and renew TLS certs from Let's Encrypt                
      |  6 letsencrypt/letsencrypt                  Python        300 This Let's Encrypt repo is an ACME client that can obtain certs and extens...
      |  7 twitter/labella.js                       JavaScript    248 Placing labels on a timeline without overlap.                                
      |  8 LeaVerou/bliss                           HTML          228 Blissful JavaScript                                                          
      |  9 nathancahill/Split.js                    JavaScript    217 Lightweight, unopinionated utility for adjustable split views                
      | 10 hashcat/oclHashcat                       C             194 World's fastest and most advanced GPGPU-based password recovery utility      
      | 11 apple/swift-package-manager              Swift         190 The Package Manager for the Swift Programming Language                       
      | 12 documentationjs/documentation            JavaScript    177 beautiful, flexible, powerful js docs                                        
      | 13 HospitalRun/hospitalrun-frontend         JavaScript    167 Ember front end for HospitalRun                                              
      | 14 NARKOZ/hacker-scripts                    JavaScript    139 Based on a true story                                                        
      | 15 apple/swift-evolution                                  140                                                                              
      | 16 MaximAbramchuck/awesome-interviews                     139 A curated awesome list of lists of interview questions. Feel free to contr...
      | 17 adleroliveira/dreamjs                    JavaScript    136 A lightweight json data generator.                                           
      | 18 huytd/swift-http                         Swift         125 HTTP Implementation for Swift on Linux and Mac OS X                          
      | 19 diafygi/gethttpsforfree                  JavaScript    118 Source code for https://gethttpsforfree.com/                                 
      | 20 apple/swift-corelibs-foundation          C              93 The Foundation Project, providing core utilities, internationalization, an...
      | 21 xenolf/lego                              Go            100 Let's Encrypt client and ACME library written in Go                          
      | 22 fengyuanchen/cropperjs                   JavaScript     95 JavaScript image cropper.                                                    
      | 23 proflin/CoolplaySpark                                   85 酷玩 Spark                                                                   
      | 24 incrediblesound/story-graph              JavaScript     87 The Graph that Generates Stories                                             
      | 25 geeeeeeeeek/WeChatLuckyMoney             Java           75 微信抢红包插件, an Android app that helps you snatch virtual red envelopes...

    EOS
  end

  def dummy_weekly_result
    <<-'EOS'.unindent
      |No. Name                                     Lang          Star
      |--- ---------------------------------------- ----------- ------
      |  1 DrkSephy/es6-cheatsheet                  JavaScript    5143
      |  2 FreeCodeCamp/FreeCodeCamp                JavaScript    4555
      |  3 Microsoft/CNTK                           C++           3548
      |  4 jiahaog/nativefier                       JavaScript    2593
      |  5 HunterLarco/voxel.css                    CSS           2054
      |  6 samshadwell/TrumpScript                  Python        1824
      |  7 Yalantis/uCrop                           Java          1731
      |  8 Soundnode/soundnode-app                  JavaScript    1230
      |  9 tensorflow/tensorflow                    C++            953
      | 10 Jam3/devtool                             JavaScript    1170
      | 11 KnuffApp/Knuff                           Objective-C   1136
      | 12 brave/browser-laptop                     JavaScript    1030
      | 13 nlf/dlite                                Go            1051
      | 14 zquestz/s                                Go             971
      | 15 milligram/milligram                      CSS            959
      | 16 themattrix/bash-concurrent               Shell          924
      | 17 kragniz/json-sempai                      Python         871
      | 18 loverajoel/jstips                        CSS            841
      | 19 chinchang/hint.css                       CSS            816
      | 20 hirak/prestissimo                        PHP            783
      | 21 rdpeng/ProgrammingAssignment2            R                8
      | 22 fengyuanchen/viewerjs                    JavaScript     729
      | 23 vhf/free-programming-books                              620
      | 24 yamartino/pressure                       JavaScript     695
      | 25 cdmedia/cms.js                           JavaScript     677

    EOS
  end

  def dummy_monthly_result
    <<-'EOS'.unindent
      |No. Name                                       Lang          Star
      |--- ------------------------------------------ ----------- ------
      |  1 FreeCodeCamp/FreeCodeCamp                  JavaScript   15567
      |  2 loverajoel/jstips                          CSS           7710
      |  3 braydie/HowToBeAProgrammer                               6786
      |  4 DrkSephy/es6-cheatsheet                    JavaScript    5127
      |  5 matryer/bitbar                             Objective-C   4946
      |  6 Microsoft/ChakraCore                       JavaScript    4689
      |  7 VerbalExpressions/JSVerbalExpressions      JavaScript    4758
      |  8 tldr-pages/tldr                            Shell         4193
      |  9 jlevy/the-art-of-command-line                            3966
      | 10 mhinz/vim-galore                           VimL          4062
      | 11 jiahaog/nativefier                         JavaScript    3932
      | 12 jlevy/og-equity-compensation                             3797
      | 13 Microsoft/CNTK                             C++           3537
      | 14 hacksalot/HackMyResume                     JavaScript    3252
      | 15 vhf/free-programming-books                               2690
      | 16 milligram/milligram                        CSS           2876
      | 17 samshadwell/TrumpScript                    Python        2718
      | 18 sindresorhus/awesome                                     2640
      | 19 donnemartin/data-science-ipython-notebooks Python        2424
      | 20 tensorflow/tensorflow                      C++           2033
      | 21 os-js/OS.js                                JavaScript    2357
      | 22 JakeLin/IBAnimatable                       Swift         2345
      | 23 viljamis/feature.js                        HTML          2239
      | 24 facebook/react-native                      Java          1962
      | 25 baidu-research/warp-ctc                    Cuda          1966

    EOS
  end

  def dummy_languages
    <<-'EOS'.unindent
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
      |Erlang
      |F#
      |Factor
      |Fancy
      |Fantom
      |FLUX
      |Forth
      |FORTRAN
      |FreeMarker
      |Frege
      |Game Maker Language
      |GAMS
      |GAP
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
      |RenderScript
      |RobotFramework
      |Rouge
      |Ruby
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
      |Stan
      |Standard ML
      |Stata
      |SuperCollider
      |Swift
      |SystemVerilog
      |Tcl
      |Tea
      |TeX
      |Thrift
      |Turing
      |TXL
      |TypeScript
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
      |300 languages
      |you can get only selected language list with '-l' option.
      |if languages is unknown, you can specify 'unkown'.
      |
    EOS
  end
end

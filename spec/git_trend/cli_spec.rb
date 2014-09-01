# encoding: utf-8
require 'spec_helper'

include GitTrend

RSpec.shared_examples_for 'since daily ranking' do
  it 'display daily ranking' do
    expect { @cli.invoke(:list, [], since: since) }.to output(dummy_result_no_options).to_stdout
  end
end

RSpec.describe GitTrend::CLI do

  describe '#list' do
    before do
      @cli = CLI.new
    end

    context 'with no option' do
      before do
        stub_request_get('trending')
      end

      it 'display daily ranking' do
        expect { @cli.list }.to output(dummy_result_no_options).to_stdout
      end
    end

    describe 'with -l option' do
      context 'with ruby' do
        before do
          stub_request_get("trending?l=#{language}")
        end
        let(:language) { 'ruby' }

        it 'display daily ranking by language' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 discourse/discourse                      Ruby           40
            |  2 Netflix/Scumblr                          Ruby           24
            |  3 Homebrew/homebrew                        Ruby           19
            |  4 remore/burn                              Ruby           23
            |  5 mina-deploy/mina                         Ruby           17
            |  6 pragmaticivan/minotauro_vagrant_rails    Ruby           16
            |  7 rails/rails                              Ruby           11
            |  8 sass/sass                                Ruby           11
            |  9 cantino/huginn                           Ruby           10
            | 10 caskroom/homebrew-cask                   Ruby            8
            | 11 presidentbeef/brakeman                   Ruby            9
            | 12 applift/fast_attributes                  Ruby           10
            | 13 krisleech/wisper                         Ruby           10
            | 14 jekyll/jekyll                            Ruby            7
            | 15 intridea/grape                           Ruby            7
            | 16 mitchellh/vagrant                        Ruby            6
            | 17 elasticsearch/logstash                   Ruby            6
            | 18 rightscale/praxis                        Ruby            7
            | 19 cerebris/jsonapi-resources               Ruby            7
            | 20 ruby/ruby                                Ruby            6
            | 21 junegunn/fzf                             Ruby            6
            | 22 digitaloceancloud/resource_kit           Ruby            6
            | 23 rapid7/metasploit-framework              Ruby            5
            | 24 tenderlove/the_metal                     Ruby            6
            | 25 bbatsov/rubocop                          Ruby            5
          EOS
          expect { @cli.invoke(:list, [], language: language) }.to output(res).to_stdout
        end
      end

      context 'with objective-c++ (including + sign)' do
        before do
          stub_request_get('trending?l=objective-c%2B%2B')
        end
        let(:language) { 'objective-c++' }

        it 'display daily ranking by language' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang            Star
            |--- ---------------------------------------- ------------- ------
            |  1 droolsjbpm/optaplanner                   Objective-C++      0
            |  2 facebook/pop                             Objective-C++      0
            |  3 johnno1962/Xtrace                        Objective-C++      0
            |  4 pivotal/cedar                            Objective-C++      0
            |  5 wetube/bitcloud                          Objective-C++      0
            |  6 mousebird/WhirlyGlobe                    Objective-C++      0
            |  7 deanm/plask                              Objective-C++      0
            |  8 jerols/PopTut                            Objective-C++      0
            |  9 otaviocc/OCBorghettiView                 Objective-C++      0
            | 10 johnno1962/XprobePlugin                  Objective-C++      0
            | 11 callmeed/pop-playground                  Objective-C++      0
            | 12 couchdeveloper/RXPromise                 Objective-C++      0
            | 13 jxd001/POPdemo                           Objective-C++      0
            | 14 otaviocc/NHCalendarActivity              Objective-C++      0
            | 15 giladno/UICoreTextView                   Objective-C++      0
            | 16 jhaynie/titanium_box2d                   Objective-C++      0
            | 17 openpeer/opios                           Objective-C++      0
            | 18 pivotal/PivotalCoreKit                   Objective-C++      0
            | 19 iolate/SimulateTouch                     Objective-C++      0
            | 20 mapbox/mapbox-gl-cocoa                   Objective-C++      0
            | 21 freerunnering/SwipeSelection             Objective-C++      0
            | 22 kseebaldt/deferred                       Objective-C++      0
            | 23 rbaumbach/Swizzlean                      Objective-C++      0
            | 24 Smartype/iOS_VPNPlugIn                   Objective-C++      0
            | 25 swift2js/swift2js                        Objective-C++      0
          EOS
          expect { @cli.invoke(:list, [], language: language) }.to output(res).to_stdout
        end
      end
    end

    describe 'with -s option' do
      before { stub_request_get("trending?since=#{since}") }

      context 'with no option' do
        let(:since) { '' }
        it_behaves_like 'since daily ranking'
      end

      context 'with daily' do
        let(:since) { 'daily' }
        it_behaves_like 'since daily ranking'
      end

      context 'with weekly' do
        let(:since) { 'weekly' }
        it 'display daily ranking since weekly' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 rxin/db-readings                                      2116
            |  2 gionkunz/chartist-js                     JavaScript   1652
            |  3 chriskiehl/Gooey                         Python       1335
            |  4 masayuki0812/c3                          JavaScript   1233
            |  5 daimajia/AndroidSwipeLayout              Java          750
            |  6 gogits/gogs                              Go            751
            |  7 kitematic/kitematic                      JavaScript    734
            |  8 tmux-plugins/tmux-resurrect              Shell         737
            |  9 fastmonkeys/stellar                      Python        642
            | 10 Yelp/dockersh                            Go            633
            | 11 sahat/satellizer                         PHP           581
            | 12 luster-io/impulse                        JavaScript    580
            | 13 AllThingsSmitty/must-watch-css                         560
            | 14 duojs/duo                                JavaScript    554
            | 15 tylertreat/chan                          C             548
            | 16 angular/angular.js                       JavaScript    378
            | 17 mattt/Surge                              Swift         459
            | 18 HubSpot/pace                             CSS           444
            | 19 trueinteractions/tint2                   C             448
            | 20 peachananr/onepage-scroll                JavaScript    386
            | 21 twbs/bootstrap                           CSS           300
            | 22 google/web-starter-kit                   CSS           372
            | 23 quasado/gravit                           JavaScript    365
            | 24 meteor/meteor                            JavaScript    362
            | 25 Netflix/Scumblr                          Ruby          305
          EOS
          expect { @cli.invoke(:list, [], since: since) }.to output(res).to_stdout
        end
      end

      context 'with monthly' do
        let(:since) { 'monthly' }
        it 'display daily ranking since monthly' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang           Star
            |--- ---------------------------------------- ------------ ------
            |  1 sahat/satellizer                         PHP            3066
            |  2 Ehesp/Responsive-Dashboard               CSS            2975
            |  3 fastmonkeys/stellar                      Python         2798
            |  4 Alamofire/Alamofire                      Swift          2579
            |  5 chriskiehl/Gooey                         Python         2509
            |  6 rxin/db-readings                                        2139
            |  7 johnpapa/angularjs-styleguide                           2014
            |  8 duojs/duo                                JavaScript     1977
            |  9 limetext/lime                            Go             1895
            | 10 angular/angular.js                       JavaScript     1412
            | 11 gionkunz/chartist-js                     JavaScript     1680
            | 12 twbs/bootstrap                           CSS            1263
            | 13 gogits/gogs                              Go             1610
            | 14 bevacqua/js                                             1570
            | 15 typicode/lowdb                           CoffeeScript   1465
            | 16 vhf/free-programming-books                              1259
            | 17 lmccart/p5.js                            JavaScript     1383
            | 18 weblinc/jquery.smoothState.js            JavaScript     1336
            | 19 masayuki0812/c3                          JavaScript     1331
            | 20 deanmalmgren/textract                    Python         1265
            | 21 ochococo/Design-Patterns-In-Swift        Swift          1230
            | 22 mbostock/d3                              JavaScript     1008
            | 23 VodkaBears/Vide                          JavaScript     1136
            | 24 driftyco/ionic                           JavaScript     1007
            | 25 fians/marka                              CSS             989
          EOS
          expect { @cli.invoke(:list, [], since: since) }.to output(res).to_stdout
        end
      end
    end

    describe 'with -d option' do

      after do
        ENV['COLUMNS'] = nil
        ENV['LINES'] = nil
      end

      context 'terminal width is enough' do
        before do
          stub_request_get('trending')
          ENV['COLUMNS'] = '140'
          ENV['LINES'] = '40'
        end

        it 'display daily ranking with description' do
          res = <<-'EOS'.unindent
            |No. Name                                       Lang          Star Description                                                               
            |--- ------------------------------------------ ----------- ------ --------------------------------------------------------------------------
            |  1 gionkunz/chartist-js                       JavaScript     363 Simple responsive charts                                                  
            |  2 kitematic/kitematic                        JavaScript     327 Simple Docker App management for Mac OS X.                                
            |  3 tmux-plugins/tmux-resurrect                Shell          217 Persists tmux environment across system restarts.                         
            |  4 rxin/db-readings                                          210 Readings in Databases                                                     
            |  5 daimajia/AndroidSwipeLayout                Java           172 The Most Powerful Swipe Layout!                                           
            |  6 tylertreat/chan                            C              126 Pure C implementation of Go channels.                                     
            |  7 AllThingsSmitty/must-watch-css                             93 A useful list of must-watch videos about CSS.                             
            |  8 masayuki0812/c3                            JavaScript      85 A D3-based reusable chart library                                         
            |  9 fouber/page-monitor                        JavaScript      74 capture webpage and diff the dom change with phantomjs                    
            | 10 gogits/gogs                                Go              71 Gogs(Go Git Service) is a painless self-hosted Git Service written in G...
            | 11 facebook/flux                              JavaScript      72 Application Architecture for Building User Interfaces                     
            | 12 twbs/bootstrap                             CSS             55 The most popular front-end framework for developing responsive, mobile ...
            | 13 luster-io/impulse                          JavaScript      68 Dynamics Physics Interactions for the Mobile Web                          
            | 14 lawloretienne/QuickReturn                  Java            65 Showcases QuickReturn view as a header, footer, and both header and foo...
            | 15 angular/angular.js                         JavaScript      53 HTML enhanced for web apps                                                
            | 16 wisk/medusa                                C               60 An open source interactive disassembler                                   
            | 17 ochococo/Design-Patterns-In-Swift          Swift           60 Design Patterns implemented in Swift                                      
            | 18 cwRichardKim/RKSwipeBetweenViewControllers Objective-C     59 Swipe between ViewControllers like in the Spotify or Twitter app with a...
            | 19 google/web-starter-kit                     CSS             59 Google Web Starter Kit (Beta)                                             
            | 20 syncthing/syncthing                        Go              49 Open Source Continuous File Synchronization                               
            | 21 ruslanskorb/RSKImageCropper                Objective-C     46 An image cropper for iOS like in the Contacts app with support for land...
            | 22 kyze8439690/ResideLayout                   Java            44 An Android Layout which has a same function like https://github.com/rom...
            | 23 ParsePlatform/f8DeveloperConferenceApp     Java            41                                                                           
            | 24 chriskiehl/Gooey                           Python          41 Turn (almost) any command line program into a full GUI application with...
            | 25 discourse/discourse                        Ruby            41 A platform for community discussion. Free, open, simple.                  
          EOS
          expect { @cli.invoke(:list, [], description: 'description') }.to output(res).to_stdout
        end
      end

      context 'terminal width is tiny' do
        before do
          stub_request_get('trending')
          ENV['COLUMNS'] = '85' # it is not enough for description.
          ENV['LINES'] = '40'
        end

        it 'display daily ranking about the same as no option' do
          expect { @cli.invoke(:list, [], description: 'description') }.to output(dummy_result_no_options).to_stdout
        end
      end
    end

    describe 'with -l and -s option' do
      context 'with ruby and weekly' do
        before do
          stub_request_get("trending?l=#{language}&since=#{since}")
        end
        let(:language) { 'ruby' }
        let(:since) { 'weekly' }

        it 'display daily ranking since weekly' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star
            |--- ---------------------------------------- ---------- ------
            |  1 Netflix/Scumblr                          Ruby          308
            |  2 tenderlove/the_metal                     Ruby          225
            |  3 remore/burn                              Ruby          191
            |  4 Homebrew/homebrew                        Ruby          121
            |  5 discourse/discourse                      Ruby          135
            |  6 rightscale/praxis                        Ruby          116
            |  7 rails/rails                              Ruby           82
            |  8 cantino/huginn                           Ruby           98
            |  9 jekyll/jekyll                            Ruby           81
            | 10 sass/sass                                Ruby           77
            | 11 orta/cocoapods-keys                      Ruby           81
            | 12 mitchellh/vagrant                        Ruby           62
            | 13 gitlabhq/gitlabhq                        Ruby           52
            | 14 caskroom/homebrew-cask                   Ruby           48
            | 15 cerebris/jsonapi-resources               Ruby           59
            | 16 rapid7/metasploit-framework              Ruby           47
            | 17 winebarrel/ridgepole                     Ruby           57
            | 18 digitaloceancloud/resource_kit           Ruby           51
            | 19 bbatsov/rubocop                          Ruby           44
            | 20 rails/web-console                        Ruby           49
            | 21 gavinlaking/vedeu                        Ruby           47
            | 22 ruby/ruby                                Ruby           41
            | 23 apotonick/paperdragon                    Ruby           46
            | 24 junegunn/fzf                             Ruby           41
            | 25 imathis/octopress                        Ruby           36
          EOS
          expect { @cli.invoke(:list, [], language: language, since: since) }.to output(res).to_stdout
        end
      end
    end
  end

  describe '#languages' do
    before do
      @cli = CLI.new
      stub_request_get('trending')
    end

    context 'with no option' do
      it 'display daily ranking' do
        res = <<-'EOS'.unindent
          |abap
          |as3
          |ada
          |agda
          |ags-script
          |alloy
          |antlr
          |apex
          |apl
          |applescript
          |arc
          |arduino
          |aspx-vb
          |aspectj
          |nasm
          |ats
          |augeas
          |autohotkey
          |autoit
          |awk
          |blitzbasic
          |blitzmax
          |bluespec
          |boo
          |brightscript
          |bro
          |c
          |csharp
          |cpp
          |ceylon
          |chapel
          |cirru
          |clean
          |clips
          |clojure
          |cobol
          |coffeescript
          |cfm
          |common-lisp
          |component-pascal
          |coq
          |crystal
          |css
          |cuda
          |cycript
          |d
          |dart
          |dm
          |dogescript
          |dot
          |dylan
          |e
          |ec
          |eiffel
          |elixir
          |elm
          |emacs-lisp
          |emberscript
          |erlang
          |fsharp
          |factor
          |fancy
          |fantom
          |flux
          |forth
          |fortran
          |frege
          |game-maker-language
          |gams
          |gap
          |glyph
          |gnuplot
          |go
          |gosu
          |grace
          |grammatical-framework
          |groovy
          |harbour
          |haskell
          |haxe
          |hy
          |idl
          |idris
          |inform-7
          |io
          |ioke
          |isabelle
          |j
          |java
          |javascript
          |jsoniq
          |julia
          |kotlin
          |krl
          |labview
          |lasso
          |livescript
          |logos
          |logtalk
          |lookml
          |lua
          |m
          |markdown
          |mathematica
          |matlab
          |max/msp
          |mercury
          |mirah
          |monkey
          |moocode
          |moonscript
          |nemerle
          |nesc
          |netlogo
          |nimrod
          |nit
          |nix
          |nu
          |objective-c
          |objective-c++
          |objective-j
          |ocaml
          |omgrofl
          |ooc
          |opa
          |opal
          |openedge-abl
          |openscad
          |ox
          |oxygene
          |pan
          |parrot
          |pascal
          |pawn
          |perl
          |perl6
          |php
          |piglatin
          |pike
          |pogoscript
          |powershell
          |processing
          |prolog
          |propeller-spin
          |puppet
          |pure-data
          |purescript
          |python
          |r
          |racket
          |ragel-in-ruby-host
          |rdoc
          |realbasic
          |rebol
          |red
          |robotframework
          |rouge
          |ruby
          |rust
          |sas
          |scala
          |scheme
          |scilab
          |self
          |bash
          |shellsession
          |shen
          |slash
          |smalltalk
          |sourcepawn
          |sqf
          |sql
          |squirrel
          |standard-ml
          |stata
          |supercollider
          |swift
          |systemverilog
          |tcl
          |tex
          |turing
          |txl
          |typescript
          |unrealscript
          |vala
          |vcl
          |verilog
          |vhdl
          |vim
          |visual-basic
          |volt
          |wisp
          |xbase
          |xc
          |xml
          |xojo
          |xproc
          |xquery
          |xslt
          |xtend
          |zephir
          |zimpl
          |
          |202 languages
          |you can get only selected language list with '-l' option.
          |if languages is unknown, you can specify 'unkown'.
          |
        EOS
        expect { @cli.languages }.to output(res).to_stdout
      end
    end
  end

  private

  def stub_request_get(stub_url)
    url = Scraper::BASE_HOST.dup
    url << "/#{stub_url}" if stub_url
    uri = URI.parse(url)

    stub_request(:get, uri)
      .to_return(
        status: 200,
        headers: { content_type: 'text/html' },
        body: load_http_stub(stub_url))
  end

  def dummy_result_no_options
    <<-'EOS'.unindent
      |No. Name                                       Lang          Star
      |--- ------------------------------------------ ----------- ------
      |  1 gionkunz/chartist-js                       JavaScript     363
      |  2 kitematic/kitematic                        JavaScript     327
      |  3 tmux-plugins/tmux-resurrect                Shell          217
      |  4 rxin/db-readings                                          210
      |  5 daimajia/AndroidSwipeLayout                Java           172
      |  6 tylertreat/chan                            C              126
      |  7 AllThingsSmitty/must-watch-css                             93
      |  8 masayuki0812/c3                            JavaScript      85
      |  9 fouber/page-monitor                        JavaScript      74
      | 10 gogits/gogs                                Go              71
      | 11 facebook/flux                              JavaScript      72
      | 12 twbs/bootstrap                             CSS             55
      | 13 luster-io/impulse                          JavaScript      68
      | 14 lawloretienne/QuickReturn                  Java            65
      | 15 angular/angular.js                         JavaScript      53
      | 16 wisk/medusa                                C               60
      | 17 ochococo/Design-Patterns-In-Swift          Swift           60
      | 18 cwRichardKim/RKSwipeBetweenViewControllers Objective-C     59
      | 19 google/web-starter-kit                     CSS             59
      | 20 syncthing/syncthing                        Go              49
      | 21 ruslanskorb/RSKImageCropper                Objective-C     46
      | 22 kyze8439690/ResideLayout                   Java            44
      | 23 ParsePlatform/f8DeveloperConferenceApp     Java            41
      | 24 chriskiehl/Gooey                           Python          41
      | 25 discourse/discourse                        Ruby            41
    EOS
  end
end

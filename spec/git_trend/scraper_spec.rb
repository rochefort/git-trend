require 'spec_helper'

include GitTrend
RSpec.describe GitTrend::Scraper do

  describe 'proxy settings' do
    before do
      allow(ENV).to receive(:[]).with('http_proxy').and_return('http://proxy_user:proxy_pass@192.168.1.99:9999')
      @scraper = Scraper.new
    end
    subject { @scraper.instance_variable_get(:@agent) }
    its(:proxy_addr) { should eq '192.168.1.99' }
    its(:proxy_user) { should eq 'proxy_user' }
    its(:proxy_pass) { should eq 'proxy_pass' }
    its(:proxy_port) { should eq 9999 }
  end

  describe '#get' do
    after do
      # reset initialize
      # warning measure: already initialized constant
      [3, 40, 10, 6, 5].each_with_index { |n, i| Rendering::DEFAULT_RULED_LINE_SIZE[i] = n }
    end

    context 'when a network error occurred' do
      before do
        stub_request(:get, Scraper::BASE_URL).
          to_return(:status => 500, :body => '[]')
      end
      let(:language) {nil}
      it { expect{ @scraper.get(language) }.to raise_error(Exception) }
    end

    context 'with no option' do
      before do
        @scraper = Scraper.new
        stub_request_get('trending')
      end
      let(:language) {nil}

      it 'display daily ranking' do
        res = <<-'EOS'.unindent
          |No. Name                                               Lang           Star  Fork
          |--- -------------------------------------------------- ------------ ------ -----
          |  1 prat0318/json_resume                               Ruby            264    15
          |  2 andlabs/ui                                         Go              185     8
          |  3 jessepollak/card                                   CSS             174     9
          |  4 fullstackio/FlappySwift                            Swift           148    44
          |  5 grant/swift-cheat-sheet                                            153    13
          |  6 Flolagale/mailin                                   Python          155     3
          |  7 numbbbbb/the-swift-programming-language-in-chinese JavaScript      120    31
          |  8 hippyvm/hippyvm                                    PHP             113     1
          |  9 neovim/neovim                                      C                83     8
          | 10 hiphopapp/hiphop                                   CoffeeScript     77     8
          | 11 interagent/http-api-design                                          78     4
          | 12 austinzheng/swift-2048                             Swift            69    16
          | 13 mdznr/What-s-New                                   Objective-C      72     2
          | 14 daneden/animate.css                                CSS              65     6
          | 15 davidmerfield/randomColor                          JavaScript       66     3
          | 16 dawn/dawn                                          Ruby             62     2
          | 17 greatfire/wiki                                                      54     9
          | 18 swift-jp/swift-guide                               CSS              45     9
          | 19 addyosmani/psi                                     JavaScript       49     0
          | 20 mtford90/silk                                      Python           47     0
          | 21 agaue/agaue                                        Go               47     0
          | 22 mentionapp/mntpulltoreact                          Objective-C      46     1
          | 23 mikepenz/AboutLibraries                            Java             45     0
          | 24 PistonDevelopers/piston-workspace                  Shell            45     0
          | 25 maxpow4h/swiftz                                    Swift            43     1
        EOS
        expect { @scraper.get(language) }.to output(res).to_stdout
      end
    end

    describe 'with -l option' do
      context 'with ruby' do
        before do
          @scraper = Scraper.new
          stub_request_get("trending?l=#{language}")
        end
        let(:language) {'ruby'}

        it 'display daily ranking by language' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang         Star  Fork
            |--- ---------------------------------------- ---------- ------ -----
            |  1 prat0318/json_resume                     Ruby          412    27
            |  2 dawn/dawn                                Ruby           57     2
            |  3 Homebrew/homebrew                        Ruby           15     7
            |  4 etsy/nagios-herald                       Ruby           18     0
            |  5 jekyll/jekyll                            Ruby           14     4
            |  6 opf/openproject                          Ruby           11     0
            |  7 caskroom/homebrew-cask                   Ruby            9     3
            |  8 rails/rails                              Ruby            6     7
            |  9 interagent/prmd                          Ruby            9     0
            | 10 mitchellh/vagrant                        Ruby            8     2
            | 11 discourse/discourse                      Ruby            7     3
            | 12 CanCanCommunity/cancancan                Ruby            7     1
            | 13 venmo/synx                               Ruby            7     0
            | 14 laravel/homestead                        Shell           6     2
            | 15 alexreisner/geocoder                     Ruby            6     0
            | 16 visionmedia/commander                    Ruby            5     0
            | 17 CocoaPods/Specs                          Ruby            0     3
            | 18 gitlabhq/gitlabhq                        Ruby            0     2
            | 19 puppetlabs/puppetlabs-apache             Ruby            0     2
            | 20 gitlabhq/gitlab-recipes                  Ruby            0     2
            | 21 Mixd/wp-deploy                           Ruby            0     1
            | 22 svenfuchs/rails-i18n                     Ruby            0     1
            | 23 Homebrew/homebrew-php                    Ruby            0     1
            | 24 sferik/twitter                           Ruby            0     1
            | 25 rightscale/rightscale_cookbooks          Ruby            0     1
          EOS
          expect { @scraper.get(language) }.to output(res).to_stdout
        end
      end

      context 'with objective-c++ (including + sign)' do
        before do
          @scraper = Scraper.new
          stub_request_get("trending?l=#{language}")
        end
        let(:language) {'objective-c++'}

        it 'display daily ranking by language' do
          res = <<-'EOS'.unindent
            |No. Name                                     Lang            Star  Fork
            |--- ---------------------------------------- ------------- ------ -----
            |  1 facebook/pop                             Objective-C++      0     0
            |  2 johnno1962/Xtrace                        Objective-C++      0     0
            |  3 pivotal/cedar                            Objective-C++      0     0
            |  4 wetube/bitcloud                          Objective-C++      0     0
            |  5 jerols/PopTut                            Objective-C++      0     0
            |  6 otaviocc/OCBorghettiView                 Objective-C++      0     0
            |  7 droolsjbpm/optaplanner                   Objective-C++      0     0
            |  8 otaviocc/NHCalendarActivity              Objective-C++      0     0
            |  9 callmeed/pop-playground                  Objective-C++      0     0
            | 10 jxd001/POPdemo                           Objective-C++      0     0
            | 11 couchdeveloper/RXPromise                 Objective-C++      0     0
            | 12 johnno1962/XprobePlugin                  Objective-C++      0     0
            | 13 openpeer/opios                           Objective-C++      0     0
            | 14 pivotal/PivotalCoreKit                   Objective-C++      0     0
            | 15 rbaumbach/Swizzlean                      Objective-C++      0     0
            | 16 andreacremaschi/ShapeKit                 Objective-C++      0     0
            | 17 Smartype/iOS_VPNPlugIn                   Objective-C++      0     0
            | 18 humblehacker/AutoLayoutDSL               Objective-C++      0     0
            | 19 hoddez/FFTAccelerate                     Objective-C++      0     0
            | 20 armadillu/ofxPanZoom                     Objective-C++      0     0
            | 21 dodikk/CsvToSqlite                       Objective-C++      0     0
            | 22 hbang/TypeStatus                         Objective-C++      0     0
            | 23 trentbrooks/ofxCoreMotion                Objective-C++      0     0
            | 24 Yonsm/CeleWare                           Objective-C++      0     0
            | 25 ccrma/miniAudicle                        Objective-C++      0     0
          EOS
          expect { @scraper.get(language) }.to output(res).to_stdout
        end
      end
    end
  end

  describe '#list_all_languages' do
    before do
      @scraper = Scraper.new
      stub_request_get('trending')
    end

    context 'with no option' do
      it 'display daily ranking' do
        res = <<-'EOS'.unindent
          |abap
          |as3
          |ada
          |agda
          |alloy
          |antlr
          |apex
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
          |bluespec
          |boo
          |brightscript
          |bro
          |c
          |csharp
          |cpp
          |ceylon
          |cirru
          |clean
          |clips
          |clojure
          |cobol
          |coffeescript
          |cfm
          |common-lisp
          |coq
          |crystal
          |css
          |cuda
          |d
          |dart
          |dcpu-16-asm
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
          |j
          |java
          |javascript
          |jsoniq
          |julia
          |kotlin
          |krl
          |lasso
          |livescript
          |logos
          |logtalk
          |lua
          |m
          |markdown
          |mathematica
          |matlab
          |max/msp
          |mercury
          |ruby
          |monkey
          |moocode
          |moonscript
          |nemerle
          |nesc
          |netlogo
          |nimrod
          |nu
          |objective-c
          |objective-c++
          |objective-j
          |ocaml
          |omgrofl
          |ooc
          |opa
          |openedge-abl
          |oxygene
          |pan
          |parrot
          |pascal
          |pawn
          |perl
          |perl6
          |php
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
          |verilog
          |vhdl
          |vim
          |visual-basic
          |volt
          |wisp
          |xbase
          |xc
          |xml
          |xproc
          |xquery
          |xslt
          |xtend
          |zephir
          |zimpl
          |
          |183 languages
          |you can get only selected language list with '-l' option.
          |if languages is unknown, you can specify 'unkown'.
          |
        EOS
        expect { @scraper.list_all_languages }.to output(res).to_stdout
      end
    end
  end

  private
    def stub_request_get(stub_file)
      params = stub_file.match(/trending\?(.+)/).to_a[1]
      url = "#{Scraper::BASE_URL}"
      url << "?#{CGI.escape(params)}" if params
      stub_request(:get, url).
        to_return(
          :status => 200,
          :headers => {content_type: 'text/html'},
          :body => load_http_stub(stub_file))
    end
end

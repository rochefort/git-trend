[![Build Status](http://img.shields.io/travis/rochefort/git-trend.svg?style=flat)](http://travis-ci.org/rochefort/git-trend)
[![Dependency Status](http://img.shields.io/gemnasium/rochefort/git-trend.svg?style=flat)](https://gemnasium.com/rochefort/git-trend)
[![Coverage Status](http://img.shields.io/coveralls/rochefort/git-trend.svg?style=flat)](https://coveralls.io/r/rochefort/git-trend)
[![Code Climate](http://img.shields.io/codeclimate/github/rochefort/git-trend.svg?style=flat)](https://codeclimate.com/github/rochefort/git-trend)
[![Gem Version](http://img.shields.io/gem/v/git-trend.svg?style=flat)](http://badge.fury.io/rb/git-trend)


# git-trend

git-trend is a command line utitlity to show [Trending repositories on GitHub](https://github.com/trending).  


## Installation

Add this line to your application's Gemfile:

    gem 'git-trend'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-trend

## Usage

Use the git-trend as follows:

### daily trending

    git trend

e.g.:

```
$ git trend
No. Name                                               Lang           Star
--- -------------------------------------------------- ------------ ------
  1 lafikl/steady.js                                   JavaScript      435
  2 rpicard/explore-flask                              Python          316
  3 dc-js/dc.js                                        JavaScript      289
  4 watilde/beeplay                                    JavaScript      272
  5 grant/swift-cheat-sheet                                            263
  6 tictail/bounce.js                                  CSS             260
  7 jessepollak/card                                   CSS             225
  8 prat0318/json_resume                               Ruby            195
  9 addyosmani/psi                                     JavaScript      201
 10 fullstackio/FlappySwift                            Swift           168
 11 PythonJS/PythonJS                                  JavaScript      185
 12 numbbbbb/the-swift-programming-language-in-chinese JavaScript      137
 13 maxpow4h/swiftz                                    Swift           134
 14 andlabs/ui                                         Go              116
 15 interagent/http-api-design                                         100
 16 dotcloud/docker                                    Go               98
 17 dwightwatson/validating                            PHP              99
 18 daneden/animate.css                                CSS              92
 19 daimajia/AndroidImageSlider                        Java             87
 20 austinzheng/swift-2048                             Swift            73
 21 Flolagale/mailin                                   Python           77
 22 hiphopapp/hiphop                                   CoffeeScript     71
 23 jas/swift-playground-builder                       JavaScript       62
 24 medyo/dynamicbox                                   Java             59
 25 twbs/bootstrap                                     CSS              46
```

### daily trending with description

    git trend -d

e.g.:

```
$ g trend -d
No. Name                                               Lang          Star Description
--- -------------------------------------------------- ----------- ------ ----------------------------------------------------------------------------
  1 hummingbird-me/hummingbird                         JavaScript     535 Probably the coolest anime discovery platform around.
  2 google/flatbuffers                                 Shell          272 Memory Efficient Serialization Library
  3 jakubroztocil/httpie                               Python         248 HTTPie is a command line HTTP client, a user-friendly cURL replacement.
  4 mephux/komanda                                     JavaScript     199 IRC for people who write code
  5 burocratik/outdated-browser                        JavaScript     188 A simple tool to identify and upgrade old browsers.
  6 numbbbbb/the-swift-programming-language-in-chinese Python         140 中文版 Apple 官方 Swift 教程《The Swift Programming Language》
  7 pocketjoso/penthouse                               JavaScript     146 Critical Path CSS Generator
  8 estiens/world_cup_json                             Ruby           126 Rails backend for a scraper that outputs World Cup data as JSON
  9 medialab/artoo                                     JavaScript     126 The client-side scraping companion.
 10 justjavac/Google-IPs                                               97 Google 全球 IP 地址库
 11 thusfresh/switchboard                              Erlang         114 Switchboard Server
 12 greatfire/wiki                                                     97
 13 montagejs/collections                              JavaScript      96 This package contains JavaScript implementations of common data structure...
 14 thumbtack/angular-smarty                           JavaScript      94 Autocomplete UI written with Angular JS.
 15 Vestorly/torii                                     JavaScript      91 A set of clean abstractions for authentication in Ember.js
 16 angular/angular.js                                 JavaScript      68 HTML enhanced for web apps
 17 urish/angular-moment                               JavaScript      79 Angular.JS directives for Moment.JS (timeago alternative)
 18 mattdonnelly/Swifter                               Swift           76 A Twitter framework for iOS & OS X written in Swift
 19 nimbly/angular-formly                              JavaScript      72 AngularJS directive which takes JSON representing a form and renders to H...
 20 julianshapiro/velocity                             JavaScript      71 Accelerated JavaScript animation.
 21 GoogleCloudPlatform/kubernetes                     Go              64 Container Cluster Manager
 22 twbs/bootstrap                                     CSS             45 The most popular front-end framework for developing responsive, mobile fi...
 23 google/cadvisor                                    Go              58 Analyzes resource usage and performance characteristics of running contai...
 24 CartoDB/odyssey.js                                 JavaScript      57 Making it easy to merge map and narrative
 25 ra1028/RACollectionViewReorderableTripletLayout    Objective-C     55 The custom collectionView layout that can perform reordering of cells by ...
```

### daily trending by language

    git trend -l

e.g.:

```
$ git trend -l ruby
No. Name                                     Lang         Star
--- ---------------------------------------- ---------- ------
  1 prat0318/json_resume                     Ruby          199
  2 dawn/dawn                                Ruby           51
  3 etsy/nagios-herald                       Ruby           27
  4 Homebrew/homebrew                        Ruby           13
  5 CanCanCommunity/cancancan                Ruby           16
  6 venmo/synx                               Ruby           16
  7 joenorton/rubyretriever                  Ruby           14
  8 jekyll/jekyll                            Ruby           10
  9 rapid7/metasploit-framework              Ruby            9
 10 discourse/discourse                      Ruby            9
 11 torben/FlappyMotion                      Ruby           10
 12 rails/rails                              Ruby            6
 13 visionmedia/commander                    Ruby            9
 14 interagent/prmd                          Ruby            9
 15 opf/openproject                          Ruby            9
 16 mitchellh/vagrant                        Ruby            8
 17 twbs/bootstrap-sass                      Ruby            8
 18 sass/sass                                Ruby            7
 19 github/hub                               Ruby            8
 20 gitlabhq/gitlabhq                        Ruby            5
 21 CocoaPods/CocoaPods                      Ruby            7
 22 plataformatec/devise                     Ruby            5
 23 wbailey/claws                            Ruby            7
 24 guard/guard                              Ruby            6
 25 jordansissel/fpm                         Ruby            6
```

### weekly/monthly trending

    git trend -s weekly
    git trend -s w
    
    or
    
    git trend -s monthly
    git trend -s m

e.g.:

```
$ git trend -s weekly
No. Name                                               Lang         Star
--- -------------------------------------------------- ---------- ------
  1 numbbbbb/the-swift-programming-language-in-chinese JavaScript   4161
  2 justjavac/Google-IPs                                            1499
  3 tictail/bounce.js                                  CSS          1779
  4 grant/swift-cheat-sheet                            JavaScript   1432
  5 GoogleCloudPlatform/kubernetes                     Go           1224
  6 jessepollak/card                                   CSS          1109
  7 facebook/Haxl                                      Haskell      1003
  8 greatfire/wiki                                                   845
  9 docker/libchan                                     Go            945
 10 lafikl/steady.js                                   JavaScript    783
 11 dotcloud/docker                                    Go            660
 12 fullstackio/FlappySwift                            Swift         603
 13 docker/libswarm                                    Go            691
 14 uutils/coreutils                                   Rust          610
 15 watilde/beeplay                                    JavaScript    542
 16 dmytrodanylyk/circular-progress-button             Java          510
 17 mooz/percol                                        Python        511
 18 fengsp/plan                                        Python        496
 19 interagent/http-api-design                                       481
 20 rpicard/explore-flask                              Python        477
 21 jdorn/json-editor                                  JavaScript    387
 22 twbs/bootstrap                                     CSS           288
 23 google/cadvisor                                    Go            371
 24 irssi/irssi                                        C             351
 25 mbostock/d3                                        JavaScript    288
```

### show languages

    git trend languages

e.g.:

```
$ git trend languages
abap
as3
ada
agda
alloy
antlr
apex
applescript
.
.
.
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/git-trend/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

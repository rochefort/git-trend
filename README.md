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
No. Name                                               Lang           Star  Fork
--- -------------------------------------------------- ------------ ------ -----
  1 lafikl/steady.js                                   JavaScript      435    12
  2 rpicard/explore-flask                              Python          316    16
  3 dc-js/dc.js                                        JavaScript      289    15
  4 watilde/beeplay                                    JavaScript      272    12
  5 grant/swift-cheat-sheet                                            263    13
  6 tictail/bounce.js                                  CSS             260     8
  7 jessepollak/card                                   CSS             225    15
  8 prat0318/json_resume                               Ruby            195    17
  9 addyosmani/psi                                     JavaScript      201     3
 10 fullstackio/FlappySwift                            Swift           168    52
 11 PythonJS/PythonJS                                  JavaScript      185     9
 12 numbbbbb/the-swift-programming-language-in-chinese JavaScript      137    30
 13 maxpow4h/swiftz                                    Swift           134     7
 14 andlabs/ui                                         Go              116     6
 15 interagent/http-api-design                                         100     9
 16 dotcloud/docker                                    Go               98    13
 17 dwightwatson/validating                            PHP              99     5
 18 daneden/animate.css                                CSS              92    18
 19 daimajia/AndroidImageSlider                        Java             87    12
 20 austinzheng/swift-2048                             Swift            73    14
 21 Flolagale/mailin                                   Python           77     4
 22 hiphopapp/hiphop                                   CoffeeScript     71     8
 23 jas/swift-playground-builder                       JavaScript       62     0
 24 medyo/dynamicbox                                   Java             59     2
 25 twbs/bootstrap                                     CSS              46    27
```

### daily trending with description

    git trend -d

e.g.:

```
$ g trend -d
No. Name                                               Lang          Star  Fork Description
--- -------------------------------------------------- ----------- ------ ----- ----------------------------------------------------------------------------
  1 hummingbird-me/hummingbird                         JavaScript     535    21 Probably the coolest anime discovery platform around.
  2 google/flatbuffers                                 Shell          272    14 Memory Efficient Serialization Library
  3 jakubroztocil/httpie                               Python         248    14 HTTPie is a command line HTTP client, a user-friendly cURL replacement.
  4 mephux/komanda                                     JavaScript     199     8 IRC for people who write code
  5 burocratik/outdated-browser                        JavaScript     188    24 A simple tool to identify and upgrade old browsers.
  6 numbbbbb/the-swift-programming-language-in-chinese Python         140    30 中文版 Apple 官方 Swift 教程《The Swift Programming Language》
  7 pocketjoso/penthouse                               JavaScript     146     4 Critical Path CSS Generator
  8 estiens/world_cup_json                             Ruby           126     9 Rails backend for a scraper that outputs World Cup data as JSON
  9 medialab/artoo                                     JavaScript     126     0 The client-side scraping companion.
 10 justjavac/Google-IPs                                               97    36 Google 全球 IP 地址库
 11 thusfresh/switchboard                              Erlang         114     0 Switchboard Server
 12 greatfire/wiki                                                     97    34
 13 montagejs/collections                              JavaScript      96     2 This package contains JavaScript implementations of common data structure...
 14 thumbtack/angular-smarty                           JavaScript      94     0 Autocomplete UI written with Angular JS.
 15 Vestorly/torii                                     JavaScript      91     0 A set of clean abstractions for authentication in Ember.js
 16 angular/angular.js                                 JavaScript      68    40 HTML enhanced for web apps
 17 urish/angular-moment                               JavaScript      79     1 Angular.JS directives for Moment.JS (timeago alternative)
 18 mattdonnelly/Swifter                               Swift           76     5 A Twitter framework for iOS & OS X written in Swift
 19 nimbly/angular-formly                              JavaScript      72     6 AngularJS directive which takes JSON representing a form and renders to H...
 20 julianshapiro/velocity                             JavaScript      71     4 Accelerated JavaScript animation.
 21 GoogleCloudPlatform/kubernetes                     Go              64     7 Container Cluster Manager
 22 twbs/bootstrap                                     CSS             45    34 The most popular front-end framework for developing responsive, mobile fi...
 23 google/cadvisor                                    Go              58     4 Analyzes resource usage and performance characteristics of running contai...
 24 CartoDB/odyssey.js                                 JavaScript      57     6 Making it easy to merge map and narrative
 25 ra1028/RACollectionViewReorderableTripletLayout    Objective-C     55     3 The custom collectionView layout that can perform reordering of cells by ...
```

### daily trending by language

    git trend -l

e.g.:

```
$ git trend -l ruby
No. Name                                     Lang         Star  Fork
--- ---------------------------------------- ---------- ------ -----
  1 prat0318/json_resume                     Ruby          199    16
  2 dawn/dawn                                Ruby           51     0
  3 etsy/nagios-herald                       Ruby           27     0
  4 Homebrew/homebrew                        Ruby           13    15
  5 CanCanCommunity/cancancan                Ruby           16     0
  6 venmo/synx                               Ruby           16     0
  7 joenorton/rubyretriever                  Ruby           14     2
  8 jekyll/jekyll                            Ruby           10     3
  9 rapid7/metasploit-framework              Ruby            9     4
 10 discourse/discourse                      Ruby            9     3
 11 torben/FlappyMotion                      Ruby           10     0
 12 rails/rails                              Ruby            6     8
 13 visionmedia/commander                    Ruby            9     1
 14 interagent/prmd                          Ruby            9     0
 15 opf/openproject                          Ruby            9     0
 16 mitchellh/vagrant                        Ruby            8     2
 17 twbs/bootstrap-sass                      Ruby            8     1
 18 sass/sass                                Ruby            7     2
 19 github/hub                               Ruby            8     0
 20 gitlabhq/gitlabhq                        Ruby            5     5
 21 CocoaPods/CocoaPods                      Ruby            7     0
 22 plataformatec/devise                     Ruby            5     4
 23 wbailey/claws                            Ruby            7     0
 24 guard/guard                              Ruby            6     1
 25 jordansissel/fpm                         Ruby            6     0
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
No. Name                                               Lang         Star  Fork
--- -------------------------------------------------- ---------- ------ -----
  1 numbbbbb/the-swift-programming-language-in-chinese JavaScript   4161  1201
  2 justjavac/Google-IPs                                            1499   650
  3 tictail/bounce.js                                  CSS          1779    90
  4 grant/swift-cheat-sheet                            JavaScript   1432   109
  5 GoogleCloudPlatform/kubernetes                     Go           1224   124
  6 jessepollak/card                                   CSS          1109    88
  7 facebook/Haxl                                      Haskell      1003    62
  8 greatfire/wiki                                                   845   252
  9 docker/libchan                                     Go            945    34
 10 lafikl/steady.js                                   JavaScript    783    21
 11 dotcloud/docker                                    Go            660   137
 12 fullstackio/FlappySwift                            Swift         603   233
 13 docker/libswarm                                    Go            691    27
 14 uutils/coreutils                                   Rust          610    33
 15 watilde/beeplay                                    JavaScript    542    24
 16 dmytrodanylyk/circular-progress-button             Java          510    63
 17 mooz/percol                                        Python        511    15
 18 fengsp/plan                                        Python        496    25
 19 interagent/http-api-design                                       481    30
 20 rpicard/explore-flask                              Python        477    31
 21 jdorn/json-editor                                  JavaScript    387    28
 22 twbs/bootstrap                                     CSS           288   200
 23 google/cadvisor                                    Go            371    23
 24 irssi/irssi                                        C             351    27
 25 mbostock/d3                                        JavaScript    288   132
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

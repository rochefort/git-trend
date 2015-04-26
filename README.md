[![Build Status](http://img.shields.io/travis/rochefort/git-trend.svg?style=flat)](http://travis-ci.org/rochefort/git-trend)
[![Dependency Status](http://img.shields.io/gemnasium/rochefort/git-trend.svg?style=flat)](https://gemnasium.com/rochefort/git-trend)
[![Coverage Status](http://img.shields.io/coveralls/rochefort/git-trend.svg?style=flat)](https://coveralls.io/r/rochefort/git-trend)
[![Code Climate](http://img.shields.io/codeclimate/github/rochefort/git-trend.svg?style=flat)](https://codeclimate.com/github/rochefort/git-trend)
[![Gem Version](http://img.shields.io/gem/v/git-trend.svg?style=flat)](http://badge.fury.io/rb/git-trend)


# git-trend

git-trend is a command line utitlity to show [Trending repositories on GitHub](https://github.com/trending).  


## Installation

    $ gem install git-trend

## Usage

Use the git-trend as follows:

### daily trending

    git trend

e.g.:

```
$ git trend
No. Name                                     Lang          Star Description
--- ---------------------------------------- ----------- ------ ---------------------------------------------------------------------------------------------------
  1 reddit/reddit                            Python         528 the code that powers reddit.com
  2 yahoo/gifshot                            JavaScript     485 JavaScript library that can create animated GIFs from media streams, videos, or images
  3 FezVrasta/bootstrap-material-design      CSS            387 Material design theme for Bootstrap 3
  4 realm/realm-java                         Java           293 Realm is a mobile database: a replacement for SQLite & ORMs
  5 Aerolab/midnight.js                      JavaScript     226 A jQuery plugin to switch fixed headers on the fly
  6 alebcay/awesome-shell                                   220 A curated list of awesome command-line frameworks, toolkits, guides and gizmos. Inspired by awes...
  7 jonathanslenders/python-prompt-toolkit   Python         215 Library for building powerful interactive command lines in Python
  8 willianjusten/awesome-svg                               130 A curated list of SVG.
  9 usablica/intro.js                        JavaScript     105 A better way for new feature introduction and step-by-step users guide for your website and proj...
 10 simoncozens/sile                         C++            102 Simon's Improved Layout Engine
 11 sferik/t                                 Ruby            85 A command-line power tool for Twitter.
 12 realm/realm-cocoa                        Objective-C     83 Realm is a mobile database: a replacement for Core Data & SQLite
 13 mubix/shellshocker-pocs                                  67 Collection of Proof of Concepts and Potential Targets for #ShellShocker
 14 hannob/bashcheck                         Shell           60 test script for shellshocker and related vulnerabilities
 15 angular/angular.js                       JavaScript      46 HTML enhanced for web apps
 16 kenwheeler/slick                         JavaScript      57 the last carousel you'll ever need
 17 Squirrel/Squirrel.Windows                C               57 An installation and update framework for Windows desktop apps
 18 jshint/fixmyjs                           JavaScript      56 Automatically fix silly lint errors.
 19 plivo/sharq-server                       Python          52 A flexible rate limited queueing system
 20 marmelab/ng-admin                        JavaScript      49 Add an AngularJS admin GUI to any RESTful API
 21 twbs/bootstrap                           CSS             38 The most popular HTML, CSS, and JavaScript framework for developing responsive, mobile first pro...
 22 CyberAgent/AMBTableViewController        Objective-C     48 Storyboard and Prototype Cells-centric block-based UITableView controller to manage complex layo...
 23 google/cadvisor                          Go              48 Analyzes resource usage and performance characteristics of running containers.
 24 vladikoff/chromeos-apk                   JavaScript      46 Run Android APKs in Chrome OS OR Chrome in OS X, Linux and Windows.
 25 nhanaswigs/htmljs                        JavaScript      47 HTML render engine and data binding (MVVM)

```

### daily trending without description

    git trend --no-description

e.g.:

```
$ git trend --no-description
No. Name                                     Lang          Star
--- ---------------------------------------- ----------- ------
  1 reddit/reddit                            Python         528
  2 yahoo/gifshot                            JavaScript     485
  3 FezVrasta/bootstrap-material-design      CSS            387
  4 realm/realm-java                         Java           293
  5 Aerolab/midnight.js                      JavaScript     226
  6 alebcay/awesome-shell                                   220
  7 jonathanslenders/python-prompt-toolkit   Python         215
  8 willianjusten/awesome-svg                               130
  9 usablica/intro.js                        JavaScript     105
 10 simoncozens/sile                         C++            102
 11 sferik/t                                 Ruby            85
 12 realm/realm-cocoa                        Objective-C     83
 13 mubix/shellshocker-pocs                                  67
 14 hannob/bashcheck                         Shell           60
 15 angular/angular.js                       JavaScript      46
 16 kenwheeler/slick                         JavaScript      57
 17 Squirrel/Squirrel.Windows                C               57
 18 jshint/fixmyjs                           JavaScript      56
 19 plivo/sharq-server                       Python          52
 20 marmelab/ng-admin                        JavaScript      49
 21 twbs/bootstrap                           CSS             38
 22 CyberAgent/AMBTableViewController        Objective-C     48
 23 google/cadvisor                          Go              48
 24 vladikoff/chromeos-apk                   JavaScript      46
 25 nhanaswigs/htmljs                        JavaScript      47

```

### daily trending by language

    git trend -l

e.g.:

```
$ git trend -l ruby
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ ----------------------------------------------------------------------------------------------------
  1 sferik/t                                 Ruby           78 A command-line power tool for Twitter.
  2 rails/rails                              Ruby           26 Ruby on Rails
  3 Homebrew/homebrew                        Ruby           23 The missing package manager for OS X.
  4 ruby/ruby                                Ruby           12 The Ruby Programming Language
  5 discourse/discourse                      Ruby           10 A platform for community discussion. Free, open, simple.
  6 diaspora/diaspora                        Ruby           12 Distributed and contextual social networking
  7 elasticsearch/logstash                   Ruby           10 logstash - logs/event transport, processing, management, search.
  8 mitchellh/vagrant                        Ruby           10 Vagrant is a tool for building and distributing development environments.
  9 increments/qiita-rb                      Ruby           10 Qiita API v2 client library and CLI tool, written in Ruby
 10 gitlabhq/gitlabhq                        Ruby            8 Open source software to collaborate on code. Follow us on twitter @gitlabhq
 11 jekyll/jekyll                            Ruby            7 Jekyll is a blog-aware, static site generator in Ruby
 12 bbatsov/ruby-style-guide                 Ruby            9 A community-driven Ruby coding style guide
 13 capistrano/capistrano                    Ruby            7 Remote multi-server automation tool
 14 intridea/grape                           Ruby            8 An opinionated micro-framework for creating REST-like APIs in Ruby.
 15 CocoaPods/CocoaPods                      Ruby            6 The Objective-C library dependency manager.
 16 thoughtbot/laptop                        Ruby            6 A shell script which turns your Linux or Mac OS X laptop into an awesome development machine.
 17 amatsuda/database_rewinder               Ruby            7 minimalist's tiny and ultra-fast database cleaner
 18 voltrb/volt                              Ruby            7 A ruby web framework where your ruby runs on both server and client
 19 Homebrew/linuxbrew                       Ruby            6 A fork of Homebrew for Linux
 20 davidcelis/spec-me-maybe                 Ruby            7 Introduces the `maybe` syntax to RSpec.
 21 peter-murach/tty                         Ruby            6 Toolbox for developing CLI clients.
 22 plataformatec/devise                     Ruby            6 Flexible authentication solution for Rails with Warden.
 23 fluent/fluentd                           Ruby            6 Fluentd data collector
 24 caskroom/homebrew-cask                   Ruby            5 A CLI workflow for the administration of Mac applications distributed as binaries
 25 cantino/huginn                           Ruby            5 Build agents that monitor and act on your behalf.  Your agents are standing by!

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
No. Name                                     Lang           Star Description
--- ---------------------------------------- ------------ ------ --------------------------------------------------------------------------------------------------
  1 FezVrasta/bootstrap-material-design      CSS            2821 Material design theme for Bootstrap 3
  2 slackhq/SlackTextViewController          Objective-C    1526 A drop-in UIViewController subclass with a growing text input view and other useful messaging f...
  3 willianjusten/awesome-svg                               1395 A curated list of SVG.
  4 Aerolab/midnight.js                      JavaScript     1351 A jQuery plugin to switch fixed headers on the fly
  5 alebcay/awesome-shell                                    743 A curated list of awesome command-line frameworks, toolkits, guides and gizmos. Inspired by awe...
  6 jonathanslenders/python-prompt-toolkit   Python          670 Library for building powerful interactive command lines in Python
  7 vladikoff/chromeos-apk                   JavaScript      608 Run Android APKs in Chrome OS OR Chrome in OS X, Linux and Windows.
  8 psaravan/JamsMusicPlayer                 Java            533 A free, powerful and elegant music player for Android.
  9 reddit/reddit                            Python          553 the code that powers reddit.com
 10 Alamofire/Alamofire                      Swift           559 Elegant HTTP Networking in Swift
 11 vgvassilev/cling                         C++             492 Cling is an interactive C++ interpreter, built on top of Clang and LLVM compiler infrastructure...
 12 shu223/iOS8-Sampler                      Objective-C     476 Code examples for the new functions of iOS 8.
 13 yahoo/gifshot                            JavaScript      487 JavaScript library that can create animated GIFs from media streams, videos, or images
 14 kenwheeler/slick                         JavaScript      439 the last carousel you'll ever need
 15 sferik/t                                 Ruby            420 A command-line power tool for Twitter.
 16 angular/angular.js                       JavaScript      325 HTML enhanced for web apps
 17 mieko/sr-captcha                         CSS             387 Article describing how the technical means by which Silk Road 1's captcha was broken.
 18 sofish/wechat.js                         JavaScript      360 微信相关的 js 操作：分享、网络、菜单
 19 robertdavidgraham/masscan                C               345 TCP port scanner, spews SYN packets asynchronously, scanning entire Internet in under 5 minutes...
 20 realm/realm-java                         Java            348 Realm is a mobile database: a replacement for SQLite & ORMs
 21 humhub/humhub                            PHP             331 HumHub - Open Source Social Network
 22 twbs/bootstrap                           CSS             259 The most popular HTML, CSS, and JavaScript framework for developing responsive, mobile first pr...
 23 mechio/takana                            CoffeeScript    341 Takana lets you see your SCSS and CSS style changes live, in the browser, as you type them
 24 davidtheclark/scalable-css-reading-list                  331 Collected dispatches from The Quest for Scalable CSS
 25 addyosmani/timing.js                     JavaScript      335 Navigation Timing API measurement helpers

```

### number of trendings

    git trend -n <number>

e.g.:

```
$ git trend -n 3
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ -----------------------------------------------------
  1 mozilla/metrics-graphics                 JavaScript   1005 A library optimized for concise, principled data g...
  2 breach/thrust                            C++           574 Chromium-based cross-platform / cross-language app...
  3 dotnet/corefx                            C#            538 This repository contains the foundational librarie...

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

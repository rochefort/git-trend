[![Build Status](http://img.shields.io/travis/rochefort/git-trend.svg?style=flat)](http://travis-ci.org/rochefort/git-trend)
[![Dependency Status](http://img.shields.io/gemnasium/rochefort/git-trend.svg?style=flat)](https://gemnasium.com/rochefort/git-trend)
[![Coverage Status](http://img.shields.io/coveralls/rochefort/git-trend.svg?style=flat)](https://coveralls.io/r/rochefort/git-trend)
[![Code Climate](http://img.shields.io/codeclimate/github/rochefort/git-trend.svg?style=flat)](https://codeclimate.com/github/rochefort/git-trend)
[![Gem Version](http://img.shields.io/gem/v/git-trend.svg?style=flat)](http://badge.fury.io/rb/git-trend)


# git-trend

`git-trend` is a gem that fetches [Trending repositories on GitHub](https://github.com/trending).  
And this also work as a command line utility.  

## Requirements

Ruby versions is 2.0 or later.

## Installation
Add this line to your application's Gemfile:

    gem 'git-trend'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-trend

## Usage Of a gem

Require it if you haven't:

    require 'git-trend'

### Fetch trending

```ruby
repos = GitTrend.get
repos.each do |r|
  puts "#{r.name} (#{r.star_count} stargazers)"
  puts "--- #{r.description}\n\n"
end

# =>
# jayphelps/git-blame-someone-else (625 stargazers)
# --- Blame someone else for your bad code.
#
# FreeCodeCamp/FreeCodeCamp (574 stargazers)
# --- The http://FreeCodeCamp.com open source codebase and curriculum. Learn to # code and help nonprofits.
#
# p-e-w/maybe (519 stargazers)
# --- See what a program does before deciding whether you really want it to happen.
# ...
```

### Use language and since options

```ruby
# language
GitTrend.get('ruby')
GitTrend.get(:ruby)

# since
GitTrend.get(since: :weekly)
GitTrend.get(since: :week)
GitTrend.get(since: :w)

# language and since
GitTrend.get('ruby', 'weekly')
GitTrend.get(:ruby, :weekly)
GitTrend.get(language: :ruby, since: :weekly)
```

### Show enable languages

    GitTrend.languages

## Usage Of a command line tool

Use the git-trend as follows:

### Fetch daily trending

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

### Fetch daily trending without description

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
  ...

```

### Fetch daily trending by language

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
  ...
```

### Fetch weekly/monthly trending

```ruby
git trend -s weekly
git trend -s week
git trend -s w

or

git trend -s monthly
git trend -s month
git trend -s m
```

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
  ...
```

### Fetch number of trending

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

### Show enable languages

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
...
```

## Tips
I use an alias command like below;
```
alias trend='g trend -n 10 && g trend -l ruby -n 5 && g trend -l JavaScript -n 5 && g trend -l objective-c -n 5 && g trend -l swift -n 3 && g trend -l php -n 3'
```

## Implementation of other language

* [andygrunwald/go-trending: Go library for accessing trending repositories and developers at Github.](https://github.com/andygrunwald/go-trending)  



## Contributing

1. Fork it ( https://github.com/rochefort/git-trend/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

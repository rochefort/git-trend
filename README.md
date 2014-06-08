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
No. Name                                                 Star  Fork
--- -------------------------------------------------- ------ -----
  1 prat0318/json_resume                                  440    30
  2 Flolagale/mailin                                      177     3
  3 watilde/beeplay                                       176     3
  4 daneden/animate.css                                   150    15
  5 jessepollak/card                                      149     9
  6 grant/swift-cheat-sheet                               134    10
  7 numbbbbb/the-swift-programming-language-in-chinese    123    24
  8 fullstackio/FlappySwift                               117    35
  9 andlabs/ui                                            101     5
 10 neovim/neovim                                          81     7
 11 hiphopapp/hiphop                                       71    11
 12 austinzheng/swift-2048                                 66    19
 13 interagent/http-api-design                             61     2
 14 davidmerfield/randomColor                              60     3
 15 dawn/dawn                                              56     2
 16 PistonDevelopers/piston-workspace                      54     0
 17 mdznr/What-s-New                                       47     1
 18 PistonDevelopers/piston                                46     2
 19 lafikl/steady.js                                       46     0
 20 mikepenz/AboutLibraries                                44     0
 21 greatfire/wiki                                         37    12
 22 goagent/goagent                                        36     7
 23 hippyvm/hippyvm                                        36     3
 24 dwightwatson/validating                                37     0
 25 jas/swift-playground-builder                           37     0
```

### daily trending by language

    git trend -l

e.g.:

```
$ git trend -l ruby
No. Name                                       Star  Fork
--- ---------------------------------------- ------ -----
  1 prat0318/json_resume                        412    27
  2 dawn/dawn                                    57     2
  3 Homebrew/homebrew                            15     7
  4 etsy/nagios-herald                           18     0
  5 jekyll/jekyll                                14     4
  6 opf/openproject                              11     0
  7 caskroom/homebrew-cask                        9     3
  8 rails/rails                                   6     7
  9 interagent/prmd                               9     0
 10 mitchellh/vagrant                             8     2
 11 discourse/discourse                           7     3
 12 CanCanCommunity/cancancan                     7     1
 13 venmo/synx                                    7     0
 14 laravel/homestead                             6     2
 15 alexreisner/geocoder                          6     0
 16 visionmedia/commander                         5     0
 17 CocoaPods/Specs                               0     3
 18 gitlabhq/gitlabhq                             0     2
 19 puppetlabs/puppetlabs-apache                  0     2
 20 gitlabhq/gitlab-recipes                       0     2
 21 Mixd/wp-deploy                                0     1
 22 svenfuchs/rails-i18n                          0     1
 23 Homebrew/homebrew-php                         0     1
 24 sferik/twitter                                0     1
 25 rightscale/rightscale_cookbooks               0     1
```

### show languages

    git trend all_languages

e.g.:

```
$ git trend all_languages
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

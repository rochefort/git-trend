[![codecov](https://codecov.io/gh/rochefort/git-trend/graph/badge.svg?token=rbh4fONhKx)](https://codecov.io/gh/rochefort/git-trend)
[![Gem Version](https://img.shields.io/gem/v/git-trend.svg?style=flat)](https://rubygems.org/gems/git-trend)


# git-trend

`git-trend` is a gem that fetches [Trending repositories on GitHub](https://github.com/trending).
It also works as a command-line tool.

## Buy me a coffee

If you'd like to support my work, you can [__buy me a coffee :coffee:__](https://www.buymeacoffee.com/rochefort). Any support, even just a kind word, is greatly appreciated!

## TOC
 * [Requirements](#requirements)
 * [Installation](#installation)
 * [Usage of a gem](#usage-of-a-gem)
 * [Usage of a command line tool](#usage-of-a-command-line-tool)
 * [Tips](#tips)
 * [Implementations in other languages](#implementations-in-other-languages)
 * [Contributing](#contributing)

## Requirements

Ruby 3.3 or later.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'git-trend'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install git-trend
```

## Usage of a gem

Require it if you haven't:

```ruby
require 'git-trend'
```

### Fetch trends

```ruby
repos = GitTrend.get
repos.each do |r|
  puts "#{r.name} (#{r.star_count} stargazers)"
  puts "--- #{r.description}\n\n"
end

# =>
# thedotmack/claude-mem (1138 stargazers)
# --- Persistent Context Across Sessions for Every Agent – Captures everything your agent does during sessions, compresses it with AI, and injects relevant context back into future sessions. Works with Claude Code, OpenClaw, Codex, Gemini, Hermes, Copilot, OpenCode + More
#
# vercel-labs/agent-desktop (3792 stargazers)
# --- Computer use CLI for AI agents
#
# max-sixty/worktrunk (437 stargazers)
# --- Worktrunk is a CLI for Git worktree management, designed for parallel AI agent workflows
# ...
```

### Use language and since options

```ruby
# language
GitTrend.get("ruby")
GitTrend.get(:ruby)

# since
GitTrend.get(since: :weekly)
GitTrend.get(since: :week)
GitTrend.get(since: :w)

# language and since
GitTrend.get("ruby", "weekly")
GitTrend.get(:ruby, :weekly)
GitTrend.get(language: :ruby, since: :weekly)
```

### Show available languages

```ruby
GitTrend.languages
```

## Usage of a command line tool

Use the git-trend as follows:

### Fetch daily trending

```sh
git trend
```

e.g.:

```
$ git trend
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
  1 thedotmack/claude-mem                    TypeScript   1138 Persistent Context Across Sessions for Every Agent – Captures everything y...
  2 vercel-labs/agent-desktop                Rust         3792 Computer use CLI for AI agents
  3 max-sixty/worktrunk                      Rust          437 Worktrunk is a CLI for Git worktree management, designed for parallel AI a...
  4 JustVugg/colibri                         C             803 A hierarchical inference engine for frontier MoE models: hot experts on th...
  5 mattpocock/skills                        Shell        1164 Skills for Real Engineers. Straight from my .agents directory.
  6 p-e-w/heretic                            Python        699 Training-free language model modification: Remove censorship, suppress slo...
  7 spotify/portal-ai-plugins                TypeScript     94
  8 floci-io/floci                           Java          219 Light, fluffy, and always free - The AWS Local Emulator alternative
  ...
```

### Fetch daily trending with JSON format

```sh
git trend -f json
git trend -f j
```

e.g.:

```
$ git trend -f json -n 3 | jq
[
  {
    "name": "thedotmack/claude-mem",
    "description": "Persistent Context Across Sessions for Every Agent – Captures everything your agent does during sessions, compresses it with AI, and injects relevant context back into future sessions. Works with Claude Code, OpenClaw, Codex, Gemini, Hermes, Copilot, OpenCode + More",
    "lang": "TypeScript",
    "all_star_count": 111442,
    "fork_count": 9710,
    "star_count": 1138
  },
  {
    "name": "vercel-labs/agent-desktop",
    "description": "Computer use CLI for AI agents",
    "lang": "Rust",
    "all_star_count": 11848,
    "fork_count": 807,
    "star_count": 3792
  },
  {
    "name": "max-sixty/worktrunk",
    "description": "Worktrunk is a CLI for Git worktree management, designed for parallel AI agent workflows",
    "lang": "Rust",
    "all_star_count": 10304,
    "fork_count": 370,
    "star_count": 437
  }
]
```

### Fetch daily trending without description

```sh
git trend --no-description
```

e.g.:

```
$ git trend --no-description
No. Name                                     Lang         Star
--- ---------------------------------------- ---------- ------
  1 thedotmack/claude-mem                    TypeScript   1138
  2 vercel-labs/agent-desktop                Rust         3792
  3 max-sixty/worktrunk                      Rust          437
  4 JustVugg/colibri                         C             803
  5 mattpocock/skills                        Shell        1164
  ...
```

### Fetch daily trending by language

```sh
git trend -l <language>
```

e.g.:

```
$ git trend -l ruby
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
  1 Homebrew/homebrew-cask                   Ruby            4 🍻 Default casks (upstream binary packages) for the package manager for ev...
  2 we-promise/sure                          Ruby           20 The personal finance app for everyone (by everyone)
  3 matteocrippa/awesome-swift               Ruby            1 A collaborative list of awesome Swift libraries and resources. Feel free t...
  4 rails/rails                              Ruby            3 Ruby on Rails
  5 huginn/huginn                            Ruby           23 Create agents that monitor and act on your behalf. Your agents are standin...
  ...
```

### Fetch weekly/monthly trending

```sh
git trend -s weekly
git trend -s week
git trend -s w
```

or

```sh
git trend -s monthly
git trend -s month
git trend -s m
```

e.g.:

```
$ git trend -s weekly
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
  1 Nutlope/hallmark                         CSS         10517 Anti-AI-slop design skill for Claude Code, Cursor, and Codex.
  2 thedotmack/claude-mem                    TypeScript   7255 Persistent Context Across Sessions for Every Agent – Captures everything y...
  3 pingdotgg/t3code                         TypeScript   9770
  4 obra/superpowers                         Shell        5956 An agentic skills framework & software development methodology that works.
  5 pbakaus/impeccable                       Rust        11754 The design vocabulary for your coding agent. Steer with polish and bolder,...
  ...
```

### Fetch number of trending

```sh
git trend -n <number>
```

e.g.:

```
$ git trend -n 3
No. Name                                     Lang         Star Description
--- ---------------------------------------- ---------- ------ -----------------------------------------------------------------------------
  1 thedotmack/claude-mem                    TypeScript   1138 Persistent Context Across Sessions for Every Agent – Captures everything y...
  2 vercel-labs/agent-desktop                Rust         3792 Computer use CLI for AI agents
  3 max-sixty/worktrunk                      Rust          437 Worktrunk is a CLI for Git worktree management, designed for parallel AI a...
```

### Show available languages

```sh
git trend languages
```

e.g.:

```
$ git trend languages
Unknown languages
1C Enterprise
2-Dimensional Array
4D
ABAP
ABAP CDS
...
Zmodel

846 languages
you can get only selected language list with '-l' option.
if languages is unknown, you can specify 'unknown'.
```

## Tips
I use an alias like this:

```sh
alias trend='git trend -n 10 && git trend -l ruby -n 5 && git trend -l JavaScript -n 5'
```

## Implementations in other languages

* [andygrunwald/go-trending: Go library for accessing trending repositories and developers at Github.](https://github.com/andygrunwald/go-trending)


## Contributing

1. Fork it ( https://github.com/rochefort/git-trend/fork )
2. Create your feature branch (`git switch -c my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

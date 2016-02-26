# lita-team

[![Build Status](https://travis-ci.org/EdgarOrtegaRamirez/lita-team.svg?branch=master)](https://travis-ci.org/EdgarOrtegaRamirez/lita-team)
[![Gem Version](https://badge.fury.io/rb/lita-team.svg)](https://badge.fury.io/rb/lita-team)
[![Coverage Status](https://coveralls.io/repos/EdgarOrtegaRamirez/lita-team/badge.svg?branch=master)](https://coveralls.io/r/EdgarOrtegaRamirez/lita-team?branch=master)
[![Code Climate](https://codeclimate.com/github/EdgarOrtegaRamirez/lita-team/badges/gpa.svg)](https://codeclimate.com/github/EdgarOrtegaRamirez/lita-team)
[![Security](https://hakiri.io/github/EdgarOrtegaRamirez/lita-team/master.svg)](https://hakiri.io/github/EdgarOrtegaRamirez/lita-team/master)

Create and manage the members of a team with Lita

## Installation

Add lita-team to your Lita instance's Gemfile:

``` ruby
gem 'lita-team'
```

## Usage

```
Lita: create <name> team - create team called <name>
Lita: delete <name> team - delete team called <name>
Lita: remove <name> team - delete team called <name>
Lita: block <name> team - block team called <name>
Lita: unblock <name> team - unblock team called <name>
Lita: list teams - list all teams
Lita: <name> team clear - clear team list
Lita: <name> team empty - clear team list
Lita: <name> team +1 - add me to team
Lita: <name> team add me - add me to team
Lita: <name> team add <member> - add member to team
Lita: <name> team -1 - remove me from team
Lita: <name> team remove me - remove me from team
Lita: <name> team remove <member> - remove member from team
Lita: <name> team confirm me - confirm attendance
Lita: <name> team remove <member> - confirm member attendance
Lita: <name> team list - list the people in the team
Lita: <name> team show - list the people in the team
Lita: <name> team set limit <value> - update team members limit
Lita: <name> team set location <value> - update team location
Lita: <name> team set icon <value> - update team icon
```

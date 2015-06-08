# lita-team

[![Build Status](https://travis-ci.org/EdgarOrtegaRamirez/lita-team.svg?branch=master)](https://travis-ci.org/EdgarOrtegaRamirez/lita-team)
[![Coverage Status](https://coveralls.io/repos/EdgarOrtegaRamirez/lita-team/badge.svg?branch=master)](https://coveralls.io/r/EdgarOrtegaRamirez/lita-team?branch=master)

Create and manage the members of a team with Lita

## Installation

Add lita-team to your Lita instance's Gemfile:

``` ruby
gem "lita-team"
```

## Usage

```
Lita: create <name> team - create team called <name>
Lita: delete <name> team - delete team called <name>
Lita: remove <name> team - delete team called <name>
Lita: list teams - list all teams
Lita: <name> team +1 - add me to team
Lita: <name> team add me - add me to team
Lita: <name> team add <user> - add user to team
Lita: <name> team -1 - remove me from team
Lita: <name> team remove me - remove me from team
Lita: <name> team remove <user> - remove <user> from team
Lita: <name> team list - list the people in the team
Lita: <name> team show - list the people in the team
Lita: <name> team clear - clear team list
Lita: <name> team empty - clear team list
```

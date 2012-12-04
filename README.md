<center>![Spokenvote Logo](http://cloud.github.com/downloads/railsforcharity/spokenvote/bluefull.png)</center>
# Spokenvote

## Introduction
Spokenvote.org is a Web-based social consensus tool for groups of any size, from a local school board to an entire nation’s people, that radically enhances the group’s ability to reach consensus via an intuitive democratic process. Deeply inspired by Wikipedia, Spokenvote is an open-source, non-profit “spark” project that we hope will set off a cascade of change all the way through national politics.

The central idea behind Spokenvote is to spontaneously capture people’s opinions and ideas as they naturally come up and then harness the power of crowds to turn those diverse views, opinions, and revelations into clear statements of consensus connected to large groups. Such a pivotal step is made possible by helping users organically adjust their own semantics (the way they phrased a vote), and as they make those adjustments, progress toward reaching a majority opinion together.

## Features

* Fast and easy user entry of ideas to capture constructive input from a group of any size
* Intelligent prompting to guide users toward agreement and adoption of positions by discovering where commonalities already exist
* Simple and elegant reporting back to the group to see where consensus stands at a glance
* Integration with Facebook and G+ to pull credentials and push user activity

The master instance work-in-progress instance is hosted <a href="http://spokenvote.herokuapp.com/">on Heroku</a>.

## Getting started

1. Setup your development environment. We recommend (develop and test) against ruby 1.9.3-p194 or higher.
2. Fork the <a href="https://github.com/railsforcharity/spokenvote" target="_blank">Spokenvote repo</a>.
3. Clone your fork locally.
4. Add the master repo as an upstream of yours (see instructions at https://help.github.com/articles/syncing-a-fork)

## Making Changes

Where possible please make your changes in small, cohesive commits. Send separate pull requests for each commit you feel is ready to be added to master.

When doing a larger piece of work, such as the following, please use a branch so others can more easily review it.

* The commit includes the addition of, or significant version changes of, gems or libraries used
* The commit is a significant new feature or rewrite of an existing feature

**Tests are always a welcome inclusion!**

## Environment

1. Edit database.example.yml and save as database.yml; this file is in .gitignore so don't worry about checking in your version. *NOTE:* Postgres is the database used in SpokenVote, you must have iit installed before taking the next step; in our experience installing through [homebrew](http://mxcl.github.com/homebrew/) is the easiest way.
2. Run <a href="http://gembundler.com/">Bundler</a> in the project's root directory to install any needed gems.
3. Create and update the database by running `rake db:setup`

## Rails for Charity Account

Participation is managed through the task system at http://RailsForCharity.org. Please create an account for yourself on that site and either pick your work from the existing tasks or add new tasks that you'd like to work on and assign to yourself.

## License

Spokenvote is a public good project distributed under the terms of either the MIT License or the GNU General
Public License (GPL) Version 2 or later.

See GPL-LICENSE and MIT-LICENSE for details.

## Developers

This project is an open source project of Spokenvote.org, supported in large measure by the efforts of RailsForCharity.org.

## FAQ

Q. Who is the intended audience for the Spokenvote web application?

A: At first small groups who need to reach consensus (e.g. non-profits); eventually envisioned to work at the national political level

## Contributing
Please see the <a href="https://github.com/railsforcharity/spokenvote/downloads/">current design wireframes here</a>.

Please ensure you read [the future] STYLE_GUIDELINES before making any contribution to this project.


[logo]: https://github.com/railsforcharity/spokenvote/blob/master/app/assets/images/bluefull.png "Logo"
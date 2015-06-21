# Spokenvote ![Build Status](https://travis-ci.org/Spokenvote/spokenvote.svg?branch=master)

## Introduction
Spokenvote.org is a Web-based social consensus tool for groups of any size, from a local school board to an entire nation’s people, that radically enhances the group’s ability to reach consensus via an intuitive democratic process. Deeply inspired by Wikipedia, Spokenvote is an open-source, non-profit “spark” project that we hope will set off a cascade of change all the way through national politics.

The central idea behind Spokenvote is to spontaneously capture people’s opinions and ideas as they naturally come up and then harness the power of crowds to turn those diverse views, opinions, and revelations into clear statements of consensus connected to large groups. Such a pivotal step is made possible by helping users organically adjust their own semantics (the way they phrased a vote), and as they make those adjustments, progress toward reaching a majority opinion together.

## Features

* Fast and easy user entry of ideas to capture constructive input from a group of any size
* Intelligent prompting to guide users toward agreement and adoption of proposals by discovering where commonalities already exist
* Simple and elegant reporting back to the group to see where consensus stands at a glance
* Integration with Facebook and G+ to pull credentials and push user activity

## How It Works

The model uses trees of related proposals, where related means forked from each other. The rules are:

 - Voters can have only one vote in each tree.
 - Further voting or forking in a tree results in user's votes getting "moved".
 - The index page shows only the top-voted proposal for each tree.

The live instance is <a href="http://spokenvote.org/"> hosted here</a>.
The work-in-progress staging instance is <a href="http://staging.spokenvote.org/"> hosted here</a>.

## Getting started

1. Setup your development environment. We recommend (develop and test) against ruby 2.1.1 or higher.
2. Fork the <a href="https://github.com/spokenvote/spokenvote" target="_blank">Spokenvote repo</a>.
3. Clone your fork locally.
4. Add the master repo as an upstream of yours (see instructions at https://help.github.com/articles/syncing-a-fork)

## Making Changes

Where possible please make your changes in small, cohesive commits. Send separate pull requests for each commit you feel is ready to be added to master.

When doing a larger piece of work, such as the following, please use a feature/topic branch so others can more easily review it.

* The commit includes the addition of, or significant version changes of, gems or libraries used
* The commit is a significant new feature or rewrite of an existing feature

The typical work flow for this is:

### One time setup
 - Add spokenvote/spokenvote as your upstream using the command
 ```
  $ git remote add upstream https://github.com/spokenvote/spokenvote.git
 ```
### Before starting a new feature
 - Fetch upstream changes to your local git
  ```
  $ git fetch --all
  ```
 - Merged upstream changes to your local
  ```
  $ git merge upstream/master
  ```
 - Create a new feature branch on local (example: may17_my_shiny_feature)
  ```
  $ git checkout -b may17_my_shiny_feature
  ```
 - Work on your feature
 - Commit your code

### Before pushing to remote master
 - Sync your local master branch from upstream master
  ```
  $ git checkout master
  $ git fetch upstream
  $ git merge upstream/master
  ```
 - Rebase your feature branch on your master
  ```
  $ git checkout may17_my_shiny_feature
  $ git rebase master
  ```
 - Push your changes to your remote
   ```
  $ git push origin checkout may17_my_shiny_feature
   ```

**Tests are always a welcome inclusion!**

## Environment

1. Edit database.example.yml and save as database.yml; this file is in .gitignore so don't worry about checking in your version. *NOTE:* Postgres is the database used in SpokenVote, you must have iit installed before taking the next step; in our experience installing through [homebrew](http://mxcl.github.com/homebrew/) is the easiest way.
2. Run <a href="http://gembundler.com/">Bundler</a> in the project's root directory to install any needed gems.
3. Create and update the database by running `rake db:setup`

## Google Places API setup (optional)

If you would like your development environment to utilitze the Google Places API when you are searching for hubs then you need to perform the following steps when setting up your environment:

1. Create an API console key (see: https://developers.google.com/maps/faq#keysystem for details)
2. Set a GOOGLE_API_KEY environmental variable with the key you created.
     For example add the following line to your .bashrc file and source it before starting your rails server
      ```
      export GOOGLE_API_KEY="insert your key value here"
      ```

## License

Spokenvote is a public good project distributed under the terms of either the MIT License or the GNU General
Public License (GPL) Version 2 or later.

See GPL-LICENSE and MIT-LICENSE for details.

## Developers

This project is an open source project of Spokenvote.org, having received significant support from RailsForCharity.org.

## FAQ

Q. Who is the intended audience for the Spokenvote web application?

A: At first small groups who need to reach consensus (e.g. non-profits); eventually envisioned to work at the national political level

## Contributing

Please ensure you read [the future] STYLE_GUIDELINES before making any contribution to this project.

[logo]: https://github.com/spokenvote/spokenvote/blob/master/app/assets/images/spokenvote_logomeg.png "Logo"
![Spokenvote Logo](/app/assets/images/spokenvote_logomeg.png)
# Spokenvote

## Introduction

Spokenvote.org is a Web-based social consensus tool for groups of any size, from a local school board to an entire nation’s people, that radically enhances the group’s ability to reach consensus via an intuitive democratic process. Deeply inspired by Wikipedia, Spokenvote is an open-source, non-profit “spark” project optimally timed to set off a forest fire of change.

The central idea behind Spokenvote is to spontaneously capture people’s opinions and ideas as they naturally come up and then harness the power of crowds to turn those diverse views, opinions, and revelations into clear statements of consensus connected to large groups. Such a pivotal step is made possible by helping users organically adjust their own semantics (the way they phrased a vote), and as they make those adjustments, progress toward reaching a majority opinion together.

## Features

* Very fast and easy user entry of ideas to capture constructive input from a group of any size
* Intelligent prompting to guide users toward agreement and adoption of positions where commonalities already exist
* Simple and elegant reporting back to the group to see where consensus stands at a glance
* Integration with Facebook and G+ to pull credentials and push user activity

The work-in-progress instance is hosted <a href="http://spokenvote.herokuapp.com/">here</a>.

## Getting started

1. Setup your development environment
2. Setup the project
3. Run `git submodule update --init` to grab our submodule dependencies (MobileFrontend)

## Environment setup

1. Follow Steps 1 & 2 from the instructions found on the <a href="http://www.phonegap.com/start" target="_blank">PhoneGap.com Getting Started Page</a> to get all the necessary software for contributing to this project.

### Checking out the source code

1. Create your own fork of the <a href="https://github.com/wikimedia/WiktionaryMobile" target="_blank">Wiktionary</a> code.
2. Clone your fork onto your computer.

## Test

Before you can run the tests, make sure the submodules are updated:
```
git submodule update --init
```

Then open up `./test/index.html` in your browser.

Some browsers will not be able to load JSON using AJAX if you run
the tests as local files (file://), so you should run them from
a web server (http://).

## License

You may use jquery.webfonts under the terms of either the MIT License or the GNU General
Public License (GPL) Version 2 or later.

See GPL-LICENSE and MIT-LICENSE for details.

## Developers

This project is an open source project of Spokenvote.org, supported in large measure by the efforts of RailsForCharity.org.

## FAQ

Q. I can't seem to find PhoneGap 1.4.1! Where can I download it?

A: Right [here][phonegap-1-4-1-download]

## Contributing
Please ensure you read STYLE_GUIDELINES before making any contribution to this project!


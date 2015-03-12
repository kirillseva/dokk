dokk: Docker utilities for R [![Build Status](https://travis-ci.org/kirillseva/dokk.svg?branch=master)](https://travis-ci.org/kirillseva/dokk) [![Coverage Status](https://coveralls.io/repos/kirillseva/dokk/badge.svg)](https://coveralls.io/r/kirillseva/dokk)
===========

Build docker images, run docker containers locally and remotely using docker-machine.

Useful for training your models in the cloud, spinning up on-demand instances
and cleaning up after you are done.

Pre-requisites:
* docker (```brew install docker```)
* docker-machine (```brew cask install docker-machine```, check http://caskroom.io)

Usage
----
```r
(function(machine_name) {
  # 1. Create the machine
  dokk::machine_DigitalOcean(machine_name, size="512mb")
  on.exit(dokk::machine_rm(machine_name))
  # 2. Build docker image from your Dockerfile
  dokk::build_image(machine_name, ".", intern = FALSE,
    params = productivus::pp("-t #{machine_name}-image"))
  # 3. Build a container from the image and run it!
  dokk::run_image(machine_name, productivus::pp("#{machine_name}-image"),
    command = 'echo hello world')
})("testmachine")
```

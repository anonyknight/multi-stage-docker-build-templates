# Multi-Stage Docker build templates

Docker and containerization becomes de-facto-standard nowadays. However, vanilla
dockerfile waste disk spaces and cost network bandwidth to transfer it.

This repo intends to provide templates to support multiple stage docker builds.
The last step only generates and wraps the necessary binary. It needs to strictly
follow Occam's razor. Unless it's necessary, don't add extra libraries.

## Philogophy

In most case, two steps builds are enough.

Step 1: install the necessary library and dependencies, build the binary
Step 2: only package the target and required executibles into docker.
Step 3: (optional) include unit tests.

## Reference

[Docker-multi-stage](https://docs.docker.com/build/building/multi-stage/)

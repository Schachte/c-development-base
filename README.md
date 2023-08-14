# C Development Environment

_Last updated: 8-13-23_

Inspired and modified from this [original blog article.](https://interrupt.memfault.com/blog/a-modern-c-dev-env)

This is my common build environment setup for C development. This is designed to be ran on Apple Silicon (ARM64). You can change the build architecture by overriding the `$ARCH` value in the `makefile`. 

The build in this repo builds with debug symbols to support debugging within your IDE such as VSCode (see section below). You can disable building with debug symbols by removing the `LDFLAGS = -g` option.

Additionally, I should also note this repository relies on `clang` and not `gcc`. Due to this, you must ensure you have installed `clang` via xcode developer tooling for Mac.

The core thing about this repo is that there is support to build, compile and develop against a Docker container that is pre-built with the required dependencies. This allows for a more portable and reproducible build environment indpendent of OS and architecture. 

## Caveats 

- Debugging within the `devcontainers` environment is not setup yet. This is mostly not working at the moment because `clang` is not installed on the build image. You can still debug by using the setup referenced in `.vscode/settings.json`.

## Building 

Builds a Docker image of all necessary dependencies for compiling.

> Note: This is compiled for amd64. If you're running on arm/apple silicon, you should ensure experimental build features are enabled on Docker and you're using virtualization with Rosetta to run the amd64 image.

```
make build-env
```

### Run env

Runs the environment in which you would actively develop against and run unit tests.

```
make run-env
```

### Run tests

Runs all unit tests and coverage checks within the `./test` directory.

> Note, this will only work if you have `ceedling` pre-installed on the host _or_ if you are in the build container shell via `make run-env`.

```
make test
```

### Run tests from Docker container

Runs all unit tests within the `./test` directory. This is the same as `make test` but it automatically spawns a Docker container for you that includes all the test deps such as `ceedling`.

```
make test-docker
```

## VSCode 

### Dev Containers 

If you're using VSCode, you can install the dev containers extension to get a nice virtualized environment to work within when using Docker and VSCode together.

This is defined via the `.devcontainer` configuration at the root. VSCode should prompt you with a window to connect to the dev container env once the extension above is enabled.

### Auto format on save

To get auto-formatting working, you must install this `clang-format` extension and the configuration within `.vscode/settings.json` will apply format on save.

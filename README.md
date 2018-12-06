# execTemplates

[![Run Status](https://api.shippable.com/projects/59c0de1db5bb22070042e614/badge?branch=master)](https://app.shippable.com/github/Shippable/execTemplates)

This project contains all the script templates that are used to execute a build
on Shippable. [ReqProc](https://github.com/Shippable/reqProc) combines the generic
templates present in this project with build data to generate
build-specific `bash` scripts. These scripts are eventually executed by [reqExec](https://github.com/Shippable/reqExec)
either on the build node or inside a Docker container.

## Development

The script templates are present in a separate folder for each supported OS.
This ensures a clean separation at the cost of slight redundancy. Read [contributing guidelines](https://github.com/Shippable/execTemplates/blob/master/CONTRIBUTING.md) for
conventions to add new scripts.

Any merged change in the project triggers Shippable assembly lines to
re-package the templates with [reqProc](https://github.com/Shippable/reqProc)
and push the updated, platform-specific Docker images for each supported OS and
architecture with `master` tag.

Once all the jobs are completed, the scripts can be tested by initializing nodes
manually in the test environment or running automated tests using [bvt](https://github.com/shippable/bvt).

Supported platforms:

| ARCHITECTURE   | OS                  |
| ------------   | --                  |
| x86_64         | Ubuntu_16.04        |
| x86_64         | macOS_10.12         |
| aarch64        | Ubuntu_16.04        |
| x86_64         | WindowsServer_2016  |

## Releases

The script templates for each supported platform are updated with every Shippable
release. The list of all Shippable releases can be found [here](https://github.com/Shippable/admiral/releases).

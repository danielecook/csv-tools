# Package

version       = "0.0.1"
author        = "Daniel E. Cook"
description   = "csv utilities"
license       = "MIT"

# Dependencies

requires "argparse >= 0.7.1", "colorize"

bin = @["csv"]
skipDirs = @["test"]

task test, "run tests":
  exec "nim c --lineDir:on --debuginfo -r tests/all"
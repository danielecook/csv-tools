# Package

version       = "0.0.1"
author        = "Daniel E. Cook"
description   = "Table Utilities (tut)"
license       = "MIT"

# Dependencies

requires "argparse >= 0.7.1", "colorize", "zip >= 0.2.1"
bin = @["tut"]
skipDirs = @["test"]

task test, "run tests":
  exec "nim c --lineDir:on --debuginfo -r tests/all"
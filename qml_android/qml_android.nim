# Nim Qml Android - Build an Android apk using nim
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import os, osproc
import private/setup

proc clean(dir: string) =
  discard exec_cmd("rm -rf " & dir & "deployment_settings.json")
  discard exec_cmd("rm -rf " & dir & "5.13.0")
  discard exec_cmd("rm -rf " & dir & "cmdline-tools")

proc main() =
  var base_dir = getCurrentDir() & "/.qml_android/"

  case param_str(1):
    of "clean":
      clean(base_dir)
    of "setup":
      setup_sdk_tools(base_dir)
      setup_qt_android(base_dir)
      setup_deployment_settings(base_dir)
    else:
      echo("Expected clean OR setup")

when is_main_module:
  main()


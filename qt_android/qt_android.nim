# Nim Qt Android - Build an Android apk using nim
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import os, osproc, json
import private/[setup, build]

proc generate_config(dir: string) =
  var deployment_settings = new_j_object()

  deployment_settings.add("sdk", new_j_string("android_29"))
  deployment_settings.add("host", new_j_string("linux-x86_64"))
  deployment_settings.add("target-architecture", new_j_string("arm64-v8a"))
# deployment_settings.add("qml-root-path", new_j_string(dir))
  deployment_settings.add("application-binary", new_j_string(dir &
      "libs/whatever.so"))

  write_file(dir & "qt_android_config.json",
      deployment_settings.pretty())

proc clean(dir: string) =
  discard exec_cmd("rm -rf " & dir & "deployment_settings.json")
  discard exec_cmd("rm -rf /home/qt")
  discard exec_cmd("rm -rf /home/androidsdk")

proc main() =
  var base_dir = getCurrentDir() & "/.qt_android/"

  case param_str(1):
    of "init":
      discard exec_cmd("mkdir .qt_android")
      generate_config(base_dir)
    of "clean":
      clean(base_dir)
    of "setup":
      if dir_exists(base_dir) == false:
        echo "Please run 'qml_android init' first"
        return

      if setup_qt_dir():
        echo "\nSETUP QT DIR FAILED. SKIPPING\n"
      if setup_sdk_tools():
        echo "\nSETUP ANDROIDSDK DIR FAILED. SKIPPING\n"
      setup_deployment_settings(base_dir)
    of "refresh":
      echo "only refresh whats needed"
      setup_deployment_settings(base_dir)
    of "check":
      echo "TODO"
    of "build":
      if build_nim_project(base_dir):
        echo "\nBUILDING NIM PROJECT FAILED. SUICIDED!\n"
        return
      echo "BUILT NIM.. NOW TRYING APK"
      if build_apk(base_dir):
        echo "\nBUILDING APK FAILED. SUICIDED!\n"
        return
    of "deploy":
      echo "TODO"
    else:
      echo("Expected clean OR setup")

when is_main_module:
  main()


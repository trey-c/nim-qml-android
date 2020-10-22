# Nim Qt Android - Build an Android apk using nim
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import system, osproc, os

proc build_nim_project*(dir: string): bool =
  set_current_dir(dir)
  discard exec_cmd("rm -rf " & dir & "output")
  discard exec_cmd("mkdir " & dir & "output")
  
  var output = "-o:" & dir & "output/libs/arm64-v8a/libexample.so"
  if exec_cmd("nim cpp --cc:clang --cpu:arm64 --os:android " & output & " --d:androidNDK ../example.nim") == 1:
    return true
  discard exec_cmd("rcc-qt5 " & dir & "../example.qrc -o output/libs/arm64-v8a/example.rcc")

proc build_apk*(dir: string): bool =
  set_current_dir(dir)
  var
    java_home = "env JAVA_HOME=/usr/lib64/jvm/java-1.8.0 "
    androiddeployqt = "/home/qt/work/install/bin/androiddeployqt "
    flags = "--output " & dir & "output/" & " --input " & dir & "deployment_settings.json " & "--android-platform android-29 --jdk /usr/lib64/jvm/java-1.8.0 --gradle"
  if exec_cmd(java_home & androiddeployqt & flags) == 1:
    return true



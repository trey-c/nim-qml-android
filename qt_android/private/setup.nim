# Nim Qt Android - Build an Android apk using nim
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import json
import system
import osproc, os

proc setup_qt_dir*(): bool =
  if exec_cmd("sudo mkdir -m777 /home/qt") == 1:
    return true
  set_current_dir("/home/qt") 
  discard exec_cmd("python3 -m aqt install 5.15.1 linux android --outputdir .")
  discard exec_cmd("mv 5.15.1 work")
  if exec_cmd("mv work/android work/install") == 1:
    return true

proc setup_sdk_tools*(): bool =
  if exec_cmd("sudo mkdir -m777 /home/androidsdk") == 1:
    return true
  set_current_dir("/home/androidsdk")

  if exec_cmd("wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip -P .") == 1:
    return true
  discard exec_cmd("unzip ./commandlinetools-linux-6609375_latest.zip -d ./cmdline-tools")
  if exec_cmd("rm ./commandlinetools-linux-6609375_latest.zip") == 1:
    return true

  var sdk_root = "--sdk_root=./cmdline-tools"
  discard exec_cmd("./cmdline-tools/tools/bin/sdkmanager --update " & sdk_root)
  if exec_cmd("./cmdline-tools/tools/bin/sdkmanager --install \"platform-tools\" \"platforms;android-29\" \"build-tools;29.0.2\" \"ndk-bundle\" " & sdk_root) == 1:
    return true

proc setup_deployment_settings*(dir: string) =
  var deployment_settings = new_j_object()

  deployment_settings.add("qt", new_j_string("/home/qt/work/install"))
  deployment_settings.add("sdk", new_j_string("/home/androidsdk/cmdline-tools"))
  deployment_settings.add("sdkBuildToolsRevision", new_j_string("29.0.2"))
  deployment_settings.add("ndk", new_j_string("/home/androidsdk/cmdline-tools/ndk-bundle"))
  deployment_settings.add("toolchain-prefix", new_j_string("llvm"))
  deployment_settings.add("tool-prefix", new_j_string("llvm"))
  deployment_settings.add("toolchain-version", new_j_string("4.9"))
  deployment_settings.add("ndk-host", new_j_string("linux-x86_64"))
  deployment_settings.add("target-architecture", new_j_string("arm64-v8a"))
  deployment_settings.add("qml-root-path", new_j_string(dir))
  deployment_settings.add("stdcpp-path", new_j_string("/home/androidsdk/cmdline-tools/ndk-bundle/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/libc++_shared.so"))
  deployment_settings.add("useLLVM", new_j_bool(true))
  deployment_settings.add("application-binary", new_j_string(dir &
      "output/libs/arm64-v8a/libexample.so"))

  write_file(dir & "deployment_settings.json",
      deployment_settings.pretty())

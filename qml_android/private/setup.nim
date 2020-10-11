# Practical RPC - Rpc framework
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import json
import system
import osproc

proc setup_qt_android*(dir: string) =
  discard exec_cmd("python3 -m aqt install 5.13.0 linux android android_arm64_v8a --outputdir " & dir)
  discard exec_cmd("rm aqtinstall.log")

proc setup_sdk_tools*(dir: string) =
  discard exec_cmd("wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip -P " & dir)
  discard exec_cmd("unzip " & dir & "commandlinetools-linux-6609375_latest.zip -d " &
      dir & "cmdline-tools")
  discard exec_cmd("rm " & dir & "commandlinetools-linux-6609375_latest.zip")

  var sdk_root = "--sdk_root=" & dir & "cmdline-tools"
  discard exec_cmd(dir & "cmdline-tools/tools/bin/sdkmanager --update " & sdk_root)
  discard exec_cmd("./tools/bin/sdkmanager --install \"platform-tools\" \"platforms;android-29\" \"build-tools;29.0.2\" \"ndk-bundle\" " & sdk_root)

proc setup_deployment_settings*(dir: string) =
  var deployment_settings = new_j_object()

  deployment_settings.add("qt", new_j_string(dir &
      "5.13.0/android_arm64_v8a"))
  deployment_settings.add("sdk", new_j_string(dir & "cmdline-tools"))
  deployment_settings.add("sdkBuildToolsRevision", new_j_string("29.0.2"))
  deployment_settings.add("ndk", new_j_string(dir & "ndk-bundle"))
  deployment_settings.add("toolchain-prefix", new_j_string("llvm"))
  deployment_settings.add("tool-prefix", new_j_string("llvm"))
  deployment_settings.add("toolchain-version", new_j_string("4.9"))
  deployment_settings.add("ndk-host", new_j_string("linux-x86_64"))
  deployment_settings.add("target-architecture", new_j_string("arm64-v8a"))
  #deployment_settings.add("android_extra_libs", new_j_string(dir & "libs"))
  deployment_settings.add("qml-root-path", new_j_string(dir))
  deployment_settings.add("stdcpp-path", new_j_string(dir &
      "ndk-bundle/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/libc++_shared.so"))
  deployment_settings.add("useLLVM", new_j_bool(true))
  deployment_settings.add("application-binary", new_j_string(dir & "binary"))

  write_file(dir & "deployment_settings.json",
      deployment_settings.pretty())



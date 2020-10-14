# Nim Qml Android - Build an Android apk using nim
# GNU Lesser General Public License, version 2.1
#
# Copyright © 2020 Trey Cutter <treycutter@protonmail.com>

import system, osproc

proc build_nim_project*(dir: string) =
  discard exec_cmd("rm -rf " & dir & "output")
  discard exec_cmd("mkdir " & dir & "output")
  discard exec_cmd("nim compileToCpp -c --cc:clang --cpu:arm64 --os:android -d:androidNDK --nimcache:" &
  dir & "output/nimcache" & " example.nim")

proc build_cpp_sources*(dir: string) =
  var
    clang = dir & "cmdline-tools/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android29-clang++ "
    sources = dir & "output/nimcache/*cpp "
    link = "-I/home/trey/.choosenim/toolchains/nim-1.2.6/lib "
    output_libs = dir & "output/libs/arm64-v8a/"
    output = "-o " & output_libs & "libexample.so "
    flags = "-std=gnu++14 -funsigned-char -lm -ldl " & output & link
  discard exec_cmd("mkdir -p " & output_libs)
  discard exec_cmd(clang & sources & flags)

proc build_apk*(dir: string) =
  discard exec_cmd("cp ../prebuilt/libDOtherSide.so " & dir & "output/libs/arm64-v8a/libDOtherSide.so")

  var
    java_home = "env JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 "
    androiddeployqt = dir & "5.13.0/android_arm64_v8a/bin/androiddeployqt "
    flags = "--output " & dir & "output/" & " --input " & dir & "deployment_settings.json " & "--android-platform " &
            "android-29 " & "--jdk " &
        "/usr/lib/jvm/java-8-openjdk-amd64 --gradle"
  discard exec_cmd(java_home & androiddeployqt & flags)



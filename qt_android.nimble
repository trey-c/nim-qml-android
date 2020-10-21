version = "0.1.0"
author = "Trey Cutter"
description = "TODO"
license = "LGPL-2.1"
bin = @["qt_android"]
srcDir = "qt_android"
backend = "cpp"

# Dependencies
requires "nim >= 1.0.4"

import strutils
from os import walkDirRec
from system import gorge_ex

task dev, "Build's qt_android":
      exec("nim c --nimcache:/tmp/nimcache/ qt_android/qt_android.nim")

task example, "Builds the example":
      exec("nim c -c --cpu:arm --os:android -d:androidNDK --noMain:on --nimcache:/tmp/nimcache/ example/example.nim --out:example")

before example:
  exec ("rcc-qt5 --binary example/example.qrc -o example/main.rcc")




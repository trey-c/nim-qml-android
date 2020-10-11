import asyncdispatch, os
import NimQml
# env JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 5.13.0/android_arm64_v8a/bin/androiddeployqt --output /home/trey/Downloads --input ./deployment_settings.json --android-platform android-29 --jdk /usr/lib/jvm/java-8-openjdk-amd64 --gradle --info

proc main() =
  var app = newQApplication()
  defer: app.delete()

  var engine = newQQmlApplicationEngine()
  defer: engine.delete()

  set_style("Material")
  engine.load("qrc:/example.qml")

  while true:
    app.process_events(0)
    try:
      poll(100)
    except:
      continue

when isMainModule:
  main()
  GC_fullcollect()

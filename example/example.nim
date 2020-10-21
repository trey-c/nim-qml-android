import asyncdispatch, os

import qt/gui/qguiapplication
import qt/qml/qqmlapplicationengine
import qt/quickcontrols2/qquickstyle
import qt/core/qobject

proc main() =
  var app = QGuiApplicaton()
  app.init()
  defer: app.delete_later()

  QResource.register_resource("example.rcc")

  var engine = QQmlApplicationEngine()
  engine.init()
  engine.load("qml/example.qml")
  defer: engine.delete_later() 

  var style = QQuickStyle()
  style.init()
  style.set_style("Material")

  while true:
    app.process_events()
    try:
      poll(100)
    except:
      continue

when isMainModule:
  main()
  GC_fullcollect()

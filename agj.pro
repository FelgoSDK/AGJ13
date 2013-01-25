# V-Play Empty Project
customFolder.source = qml
DEPLOYMENTFOLDERS += customFolder

# if Symbian or Meego want to be addressed, have a look at the demo games how to set up the capabilities for Symbian and the desktop icon for Meego

# Add sources
SOURCES += main.cpp

# this must be written AFTER deploymentfolders was defined!
include($$PWD/projectinclude.pri)


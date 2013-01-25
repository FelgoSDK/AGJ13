# Project file including V-Play libraries and paths for specific build target

# Set gcc 4.6 on Linux machines
linux-g++ {
  QMAKE_CC = gcc-4.6
  QMAKE_LINK_C       = $$QMAKE_CC
  QMAKE_LINK_C_SHLIB = $$QMAKE_CC
  QMAKE_CXX = g++-4.6
  QMAKE_LINK       = $$QMAKE_CXX
  QMAKE_LINK_SHLIB = $$QMAKE_CXX
}

# Set SDK and base path
macx|win32|linux-g++: {
  # Paths for Windows Mac OS X, and Linux
  VPLAY_BASE_PATH = $$[QT_INSTALL_PREFIX]/../../../V-PlaySDK
  VPLAY_SDK_PATH = $$VPLAY_BASE_PATH
} else: contains(MEEGO_EDITION,harmattan) {
  # Paths for MeeGo
  VPLAY_BASE_PATH = $$[QT_INSTALL_PREFIX]/../../../SDKs/V-PlaySDK
  VPLAY_SDK_PATH = $$[QT_INSTALL_PREFIX]/../../../../Desktop/V-PlaySDK
} else: symbian: {
  # Paths for Symbian
  VPLAY_BASE_PATH = $$[QT_INSTALL_PREFIX]../V-PlaySDK
  VPLAY_SDK_PATH = $$[QT_INSTALL_PREFIX]../../../Desktop/V-PlaySDK
}

# Resolve paths
VPLAY_INCLUDE_PATH = $$VPLAY_SDK_PATH/include
VPLAY_LIBRARY_PATH = $$VPLAY_BASE_PATH/lib
VPLAY_QML_PATH = $$VPLAY_SDK_PATH/qml

# check if the environment variable VPLAY_TEST_LOCALLY is set to 1
TEST_LOCALLY = $$(VPLAY_TEST_LOCALLY)
contains(TEST_LOCALLY, 1): {
    CONFIG += testLocally
    message(VPLAY_TEST_LOCALLY environment variable is set to 1)
}

# Only used for local debugging
testLocally {
  message(testLocally config variable is set...)
  VPLAY_BASE_PATH = $$PWD/../..
  VPLAY_SDK_PATH = $$VPLAY_BASE_PATH
  VPLAY_INCLUDE_PATH = $$VPLAY_SDK_PATH/src
  VPLAY_QML_PATH = $$VPLAY_SDK_PATH/qml

  macx|win32|linux-g++: {
    DEFINES += VPLAY_QML_PATH=\\\"$$VPLAY_SDK_PATH/qml\\\"
    message(VPLAY_QML_PATH set to $$VPLAY_SDK_PATH/qml)
  }

  linux-g++: VPLAY_LIBRARY_PATH = $$VPLAY_SDK_PATH/lib/linux
  symbian: VPLAY_LIBRARY_PATH = $$VPLAY_SDK_PATH/lib/symbian
  contains(MEEGO_EDITION,harmattan): VPLAY_LIBRARY_PATH = $$VPLAY_SDK_PATH/lib/meego
  win32: VPLAY_LIBRARY_PATH = $$VPLAY_SDK_PATH/lib/windows
  macx: VPLAY_LIBRARY_PATH = $$VPLAY_SDK_PATH/lib/macx
}

# Set paths
INCLUDEPATH += $$VPLAY_INCLUDE_PATH
DEPENDPATH += $$VPLAY_INCLUDE_PATH
QML_IMPORT_PATH += $$VPLAY_QML_PATH

# Add platform specific libraries
macx {
  DEFINES += PLATFORM_MAC
  # Frameworks
  LIBS += -framework Cocoa
  LIBS += -framework OpenGL
  LIBS += -framework OpenAL
  LIBS += -framework AudioToolbox

  # Third party libraries
  LIBS += -L$$VPLAY_LIBRARY_PATH/third_party -lcurl -lfreetype -ljpeg -lpng14 -lxml2 -lz

  # V-Play libraries
  CONFIG(release, debug|release): LIBS += -L$$VPLAY_LIBRARY_PATH -lVPlay
  else:CONFIG(debug, debug|release): LIBS += -L$$VPLAY_LIBRARY_PATH -lVPlay_debug

} else: win32 {
  DEFINES += PLATFORM_WINDOWS
  # Third party libraries
  LIBS += -L$$VPLAY_LIBRARY_PATH/third_party -llibcurl_imp -llibEGL -llibgles_cm -llibiconv -llibjpeg -llibpng -llibxml2 -llibzlib -lpthreadVCE2
  LIBS += -lWinMM -lAdvAPI32 -lGdi32 -lshell32 -lUser32
  LIBS += -lkernel32 -lwinspool -lcomdlg32 -lole32 -loleaut32 -luuid -lodbc32 -lodbccp32

  # V-Play libraries
  CONFIG(release, debug|release): LIBS += -L$$VPLAY_LIBRARY_PATH -lVPlay
  else:CONFIG(debug, debug|release): LIBS += -L$$VPLAY_LIBRARY_PATH -lVPlayd

} else: symbian {
  DEFINES += PLATFORM_SYMBIAN
  # V-Play libraries
  CONFIG(release, debug|release): LIBS += -lVPlay
  CONFIG(debug, debug|release): LIBS += -lVPlay_debug
  # the below doesnt work, the library cat be found with the tools/checklib.exe
  #CONFIG(release, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/VPlay.lib
  #else:CONFIG(debug, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/VPlay_debug.lib

  # Third party libraries
  LIBS += -lusrt2_2.lib # (QTCREATORBUG-5589)
  # LIBS += -lcharconv

  # Symbian specific permissions
  TARGET.CAPABILITY += NetworkServices ReadUserData WriteUserData

  # increase the stack and heap size, otherwise the app may crash when it is too big
  TARGET.EPOCSTACKSIZE = 0x14000
  TARGET.EPOCHEAPSIZE = 0x020000 0x8000000

  MMP_RULES += EXPORTUNFROZEN
  MMP_RULES += "OPTION gcce -march=armv6"
  MMP_RULES += "OPTION gcce -mfpu=vfp"
  MMP_RULES += "OPTION gcce -mfloat-abi=softfp"
  MMP_RULES += "OPTION gcce -marm"
  MMP_RULES += "OPTION gcce -fno-use-cxa-atexit"

  LIBS += -llibEGL -llibgles_cm
  LIBS += -lcone -leikcore -lavkon
  LIBS += -lremconcoreapi -lremconinterfacebase -lmmfdevsound

  QT += xml
  CONFIG += mobility
  MOBILITY += multimedia systeminfo sensors

} else: contains(MEEGO_EDITION,harmattan) {
  DEFINES += PLATFORM_MEEGO
  # V-Play libraries
  CONFIG(release, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/libVPlay.a
  else:CONFIG(debug, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/libVPlay_debug.a

  QT += meegographicssystemhelper
  LIBS += -lpthread -lxml2 -lEGL -lGLES_CM

  QT += xml
  CONFIG += mobility
  MOBILITY += multimedia systeminfo sensors

} else: linux-g++ {
  DEFINES += PLATFORM_LINUX
  # V-Play libraries

  linux-g++:contains(QMAKE_HOST.arch, x86_64): {
      VPLAY_LIBRARY_PATH = $$VPLAY_LIBRARY_PATH/lib64
  }

  CONFIG(release, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/libVPlay.a
  else:CONFIG(debug, debug|release): LIBS += $$VPLAY_LIBRARY_PATH/libVPlay_debug.a

  # Third party libraries
  THIRDPARTY_LIBRARY_PATH = $$VPLAY_LIBRARY_PATH/third_party

  message(V-Play 3rdparty library path: $$THIRDPARTY_LIBRARY_PATH)

  COCOSDENSIONLIBRARYPATH = $$THIRDPARTY_LIBRARY_PATH
  LIBS += $$COCOSDENSIONLIBRARYPATH/libcocosdenshion.so
  QMAKE_LFLAGS += -Wl,--rpath=$$COCOSDENSIONLIBRARYPATH
  QMAKE_LFLAGS_RPATH =

  LIBS += -L$$THIRDPARTY_LIBRARY_PATH
  LIBS += -lglfw -lGL
  LIBS += -lcurl -lfreetype -ljpeg -lxml2
}

# ------------------------ PLUGINS ------------------------ #
VPlayPluginsGenericFolder.target = plugins
VPlayPluginsGenericFolder.source = $$VPLAY_SDK_PATH/plugins/generic
DEPLOYMENTFOLDERS += VPlayPluginsGenericFolder

contains(DEFINES, PLATFORM_WINDOWS): platformPluginPath = plugins/windows
else: contains(DEFINES, PLATFORM_MAC): platformPluginPath = plugins/macx
else: contains(DEFINES, PLATFORM_LINUX): platformPluginPath = plugins/linux
else: contains(DEFINES, PLATFORM_IOS): platformPluginPath = plugins/ios
else: contains(DEFINES, PLATFORM_ANDROID): platformPluginPath = plugins/android
else: contains(DEFINES, PLATFORM_SYMBIAN): platformPluginPath = plugins/symbian
else: contains(DEFINES, PLATFORM_MEEGO): platformPluginPath = plugins/meego

VPlayPluginsPlatformFolder.target = plugins
VPlayPluginsPlatformFolder.source = $$VPLAY_SDK_PATH/$$platformPluginPath
DEPLOYMENTFOLDERS += VPlayPluginsPlatformFolder

QML_IMPORT_PATH += $$VPlayPluginsPlatformFolder.source
QML_IMPORT_PATH += $$VPlayPluginsGenericFolder.source

# Print paths for debug purposes and support requests
message(V-Play SDK path: $$VPLAY_SDK_PATH)
message(V-Play target path: $$VPLAY_BASE_PATH)
message(V-Play library path: $$VPLAY_LIBRARY_PATH)
message(V-Play qml path: $$VPLAY_QML_PATH)
message(V-Play include path: $$VPLAY_INCLUDE_PATH)
message(VPlayPluginsGenericPath: $$VPlayPluginsGenericFolder.source)
message(VPlayPluginsPlatformPath: $$VPlayPluginsPlatformFolder.source)
message(QML_IMPORT_PATH: $$QML_IMPORT_PATH)

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/vplayqmlapplicationviewer.pri)
qtcAddDeployment()


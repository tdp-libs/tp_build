# For documentation of the supported variabls see:
# https://github.com/tdp-libs/tp_build/blob/master/documentation/variables.md

# This makes Qt Creator add ../lib to the library path so that we dont need to add it manually.
LIBRARYPATHS+=../lib

exists($${OUT_PWD}/../GLOBALS.pri) {
include($${OUT_PWD}/../GLOBALS.pri)
}

exists(../../$${PROJECT_DIR}/project.conf) {
include(../../$${PROJECT_DIR}/project.conf)
}

exists(../../$${TARGET}/dependencies.pri) {
include(../../$${TARGET}/dependencies.pri)
}

include(x_parse_modules_dependencies.pri)

# Bring in the dependencies tree
include(parse_dependencies.pri)

TP_RC_EXCLUDE_FILE=
exists(../../$${PROJECT_DIR}/rc_excludes.txt) {
TP_RC_EXCLUDE_FILE=$$absolute_path(../../$${PROJECT_DIR}/rc_excludes.txt)
}

INCLUDEPATHS = $$unique(INCLUDEPATHS)
for(INCLUDE, INCLUDEPATHS) {
  INCLUDEPATH += $$absolute_path($${INCLUDE}, "$$PWD/../../")
}

# Hack to make Qt Creator parse the emscripten code model correctly.
SYSTEM_INCLUDEPATHS_QT_CREATOR = $$unique(SYSTEM_INCLUDEPATHS_QT_CREATOR)
for(INCLUDE, SYSTEM_INCLUDEPATHS_QT_CREATOR) {
  unix{
    INCLUDEPATH += $${INCLUDE}
    QMAKE_CFLAGS   += -isystem $${INCLUDE}
    QMAKE_CXXFLAGS += -isystem $${INCLUDE}
  }else{
    INCLUDEPATH += $${INCLUDE}
  }
}

RELATIVE_SYSTEM_INCLUDEPATHS = $$unique(RELATIVE_SYSTEM_INCLUDEPATHS)
for(INCLUDE, RELATIVE_SYSTEM_INCLUDEPATHS) {
  unix{
    QMAKE_CFLAGS   += -isystem $$absolute_path($${INCLUDE}, "$$PWD/../../")
    QMAKE_CXXFLAGS += -isystem $$absolute_path($${INCLUDE}, "$$PWD/../../")
  }else{
    INCLUDEPATH += $$absolute_path($${INCLUDE}, "$$PWD/../../")
  }
}

# win32{
#   QMAKE_CFLAGS   += /experimental:external /external:anglebrackets
#   QMAKE_CXXFLAGS += /experimental:external /external:anglebrackets
# }


SYSTEM_INCLUDEPATHS = $$unique(SYSTEM_INCLUDEPATHS)
for(INCLUDE, SYSTEM_INCLUDEPATHS) {
  unix{
    QMAKE_CFLAGS   += -isystem $${INCLUDE}
    QMAKE_CXXFLAGS += -isystem $${INCLUDE}
  # }win32{
  #   QMAKE_CFLAGS   += /external:I\"$${INCLUDE}\"
  #   QMAKE_CXXFLAGS += /external:I\"$${INCLUDE}\"
  }else{
    INCLUDEPATH += $${INCLUDE}
  }
}

DEFINES += TP_GIT_BRANCH=$$TP_GIT_BRANCH
DEFINES += TP_GIT_COMMIT=$$TP_GIT_COMMIT
DEFINES += TP_GIT_COMMIT_NUMBER=$$TP_GIT_COMMIT_NUMBER

INCLUDEPATH = $$unique(INCLUDEPATH)
DEFINES = $$unique(DEFINES)

LIBRARIES = $$reverse(LIBRARIES)
for(LIB, LIBRARIES) {
  !equals(TARGET, $${LIB}){
    LIBS += -l$${LIB}
  }
}

for(LIBRARYPATH, LIBRARYPATHS) {
  LIBS += -L$${LIBRARYPATH}
}

for(MODULE, MODULES) {
  TP_INJECT=
  include(../../$${MODULE}/inject.pri)
  contains(TP_INJECT, $${TARGET}) {
    include(../../$${MODULE}/vars.pri)
  }
}

equals(TEMPLATE, test) {
  TEMPLATE = app
  IS_TEST = test
}

# Win32 also needs static libs in libraries
equals(TEMPLATE, app)|equals(TEMPLATE, pylib)|win32 {
  for(LIB, SLIBS) {
    LIBS += -l$${LIB}
  }
}

equals(TEMPLATE, pylib) {
  TEMPLATE = lib
  CONFIG += no_plugin_name_prefix
  CONFIG += pylib
}

OBJECTS_DIR = ./obj/
MOC_DIR = ./moc/

QMAKE_LIBDIR += ../bin
QMAKE_LIBDIR += ../lib
QMAKE_LIBDIR += ..
QMAKE_LIBDIR += .

CONFIG(debug, debug|release) {
  DEFINES += TP_DEBUG
}

#== Special handling for Android ===================================================================
android{
  DEFINES += TP_ANDROID

  QMAKE_CFLAGS   += -frtti
  QMAKE_CXXFLAGS += -frtti
  QMAKE_LFLAGS   += -frtti

  QMAKE_LFLAGS += -Wl,--export-dynamic
  QMAKE_LFLAGS += -Wl,-E
  QMAKE_LFLAGS += -Bsymbolic

  #If we are building the executable we will also need to list all of the libs that it depends on
  contains(TEMPLATE, app) {
    DESTDIR = ../bin/

    MESSAGE = $$replace(LIBS, "-l", "")
    for(a, MESSAGE) {
      ANDROID_EXTRA_LIBS += $${OUT_PWD}/../lib/lib$${a}.so
    }
  }

  #If we are building a lib just do the usual
  !contains(TEMPLATE, app): DESTDIR = ../lib/

  CONFIG += c++1z  
}


#== Special handling for Windows ===================================================================
else:win32{
  DEFINES += TP_WIN32

  CONFIG += win32_static

  win32_static{
    DEFINES+=TP_WIN32_STATIC

    # Fix the issue where static libs don't trigger a re-link of dependent libs.
    QMAKE_POST_LINK = "copy /Y NUL $$shell_path($${OUT_PWD}/$${TARGET}.txt) > NUL"
    system("copy /Y NUL $$shell_path($${OUT_PWD}/$${TARGET}.txt) > NUL")
    for(DEPENDENCY, ALL_DEPENDENCIES) {
      TARGETDEPS += $${OUT_PWD}/../$${DEPENDENCY}/$${DEPENDENCY}.txt
    }
  }

  contains(TEMPLATE, app){
    DESTDIR = ../bin/
  }
  else{
    DESTDIR = ../lib/
  }

  winrt:INCLUDEPATH += $$_PRO_FILE_PWD_/moc/

  contains(TEMPLATE, lib){
    pylib{

    }else:win32_static{
      CONFIG += staticlib
    }
  }
  else:contains(TEMPLATE, app){
    CONFIG += reverse_libs
  }

  CONFIG += c++2a
  win32-msvc* {
    QMAKE_CXXFLAGS *= /std:c++20
    QMAKE_CXXFLAGS *= /bigobj    # Win32 issue in exprtk.hpp
    DEFINES += TP_WIN32_MSVC
    DEFINES += _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING
  }
  else {
    DEFINES += TP_WIN32_MINGW
    QMAKE_CXXFLAGS *= -std=c++20
    QMAKE_CXXFLAGS *= -Wa,-mbig-obj
    #QMAKE_LFLAGS *= -fuse-ld=bfd
  }

}


#== Special handling for OSX =======================================================================
else:osx{
  DEFINES += TP_OSX
  contains(TEMPLATE, app): DESTDIR = ../bin/
  contains(TEMPLATE, lib){
    DESTDIR = ../lib/
    CONFIG += staticlib
  }
  CONFIG += c++1z
  QMAKE_MACOSX_DEPLOYMENT_TARGET = 13.0

  #Silence SDK version warning on Mac.
  CONFIG+=sdk_no_version_check

  CONFIG(debug, debug|release) {
    tp_sanitize {
      #dnf install libasan
      QMAKE_CXXFLAGS += -fsanitize=address
      QMAKE_LFLAGS   += -fsanitize=address

      #dnf install libubsan
      QMAKE_CXXFLAGS += -fsanitize=undefined
      QMAKE_LFLAGS   += -fsanitize=undefined

      QMAKE_CXXFLAGS += -fsanitize-address-use-after-scope
      QMAKE_LFLAGS   += -fsanitize-address-use-after-scope

      QMAKE_CXXFLAGS += -fstack-protector-all
      QMAKE_LFLAGS   += -fstack-protector-all

      DEFINES += TP_SANITIZE
    }
  }
}

#== Special handling for iOS =======================================================================
else:iphoneos{
  DEFINES += TP_IOS
  contains(TEMPLATE, app): DESTDIR = ../bin/
  contains(TEMPLATE, lib): DESTDIR = ../lib/

  CONFIG += c++1z

  #Silence SDK version warning on iOS.
  CONFIG+=sdk_no_version_check
}


#== Everything else ================================================================================
else{
  linux{
    DEFINES += TP_LINUX
  }

  contains(TEMPLATE, app): DESTDIR = ../bin/
  contains(TEMPLATE, lib): DESTDIR = ../lib/

  CONFIG += c++20

  QMAKE_CXXFLAGS += -Wpedantic
  QMAKE_CXXFLAGS += -Wall
  QMAKE_CXXFLAGS += -Wextra
  QMAKE_CXXFLAGS += -Wdouble-promotion
  QMAKE_CXXFLAGS += -Wold-style-cast
  #QMAKE_CXXFLAGS += -Wconversion # very noisy in Qt headers

  isEmpty(QT){

  }else{
    QMAKE_CXXFLAGS += -isystem $$[QT_INSTALL_HEADERS]
    QMAKE_CXXFLAGS += -isystem $$[QT_INSTALL_HEADERS]/QtGui
  }

  CONFIG(debug, debug|release) {
    tp_sanitize {
      #dnf install libasan
      QMAKE_CXXFLAGS += -fsanitize=address
      QMAKE_LFLAGS   += -fsanitize=address

      #dnf install libubsan
      QMAKE_CXXFLAGS += -fsanitize=undefined
      QMAKE_LFLAGS   += -fsanitize=undefined

      QMAKE_CXXFLAGS += -fsanitize-address-use-after-scope
      QMAKE_LFLAGS   += -fsanitize-address-use-after-scope

      QMAKE_CXXFLAGS += -fstack-protector-all
      QMAKE_LFLAGS   += -fstack-protector-all

      DEFINES += TP_SANITIZE
    }

    tp_sanitize_thread {
      #dnf install libtsan
      QMAKE_CXXFLAGS += -fsanitize=thread
      QMAKE_LFLAGS   += -fsanitize=thread
      DEFINES += TP_SANITIZE_THREAD=1
    }

    tp_prof {
      #Generate output for prof
      QMAKE_CXXFLAGS += -pg
      QMAKE_LFLAGS   += -pg
    }
  }
}

include(host_cxx.pri)

#Correct the order of libs
LIBS = $$unique(LIBS)
staticlib|reverse_libs {
  LIBS = $$reverse(LIBS)
}

include(copy.pri)
include(rc.pri)
include(static_init.pri)
include(tr.pri)

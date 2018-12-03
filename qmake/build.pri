
exists(../../project.inc) {
include(../../project.inc)
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

for(INCLUDE, INCLUDEPATHS) {
  STARTS_WITH_RESULT = $$find(INCLUDE, "^/")
  count(STARTS_WITH_RESULT, 1){
    INCLUDEPATH += $${INCLUDE}
  } else {
    INCLUDEPATH += $$PWD/../../$${INCLUDE}
  }
}

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

equals(TEMPLATE, app) {
  for(LIB, SLIBS) {
    LIBS += -l$${LIB}
  }
}

OBJECTS_DIR = ./obj/
MOC_DIR = ./moc/

QMAKE_LIBDIR += ../bin
QMAKE_LIBDIR += ../lib
QMAKE_LIBDIR += ..
QMAKE_LIBDIR += .

#Correct the order of libs
LIBS = $$unique(LIBS)
staticlib{
LIBS = $$reverse(LIBS)
}

#== Special handling for Android ===================================================================
android{
DEFINES += TDP_ANDROID

#If we are building the executable we will also need to list all of the libs that it depends on
contains(TEMPLATE, app) {

DESTDIR = ../bin/

#PLATFORM_ABSTRACTIONS
MESSAGE = $$replace(LIBS, "-l", "")
for(a, MESSAGE) {
ANDROID_EXTRA_LIBS += $${OUT_PWD}/../lib/lib$${a}.so
}
}

#If we are building a lib just do the usual
!contains(TEMPLATE, app): DESTDIR = ../lib/

CONFIG += c++14
DEFINES += TDP_CPP_VERSION=17

QMAKE_LIBS_EGL = -lGLESv3
QMAKE_LIBS_OPENGL = -lGLESv3
QMAKE_LIBS_OPENGL_ES1 = -lGLESv3
QMAKE_LIBS_OPENGL_ES2 = -lGLESv3
}


#== Special handling for Windows ===================================================================
else:win32{
DESTDIR = ../lib/
winrt:INCLUDEPATH += $$_PRO_FILE_PWD_/moc/

CONFIG += c++1z
DEFINES += TDP_CPP_VERSION=17
}


#== Special handling for OSX =======================================================================
else:osx{
DEFINES += TDP_OSX
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib){
  DESTDIR = ../lib/
  CONFIG += staticlib
}
CONFIG += c++1z
DEFINES += TDP_CPP_VERSION=17

#Silence SDK version warning on Mac.
CONFIG+=sdk_no_version_check
}

#== Special handling for iOS =======================================================================
else:iphoneos{
DEFINES += TDP_IOS
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib): DESTDIR = ../lib/

CONFIG += c++1z
DEFINES += TDP_CPP_VERSION=17

#Silence SDK version warning on iOS.
CONFIG+=sdk_no_version_check
}


#== Everything else ================================================================================
else{
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib): DESTDIR = ../lib/

CONFIG += c++1z
DEFINES += TDP_CPP_VERSION=17

CONFIG(debug, debug|release) {
  QMAKE_CXXFLAGS += -Wpedantic
 #dnf install libasan
 #QMAKE_CXXFLAGS += -fsanitize=address
 #QMAKE_LFLAGS   += -fsanitize=address
 #dnf install libubsan
 #QMAKE_CXXFLAGS += -fsanitize=undefined
 #QMAKE_LFLAGS   += -fsanitize=undefined

 #QMAKE_CXXFLAGS += -fsanitize-address-use-after-scope
 #QMAKE_LFLAGS   += -fsanitize-address-use-after-scope

 #QMAKE_CXXFLAGS += -fstack-protector-all
 #QMAKE_LFLAGS   += -fstack-protector-all
 # #dnf install libtsan
 # QMAKE_CXXFLAGS += -fsanitize=thread
 # QMAKE_LFLAGS   += -fsanitize=thread
 # #Generate output for prof
 # QMAKE_CXXFLAGS += -pg
 # QMAKE_LFLAGS   += -pg
}
}

# Copies the given files to the destination directory
#Use:
#TDP_COPY += file.xyz
defineTest(tdpCopy) {
  files = $$1

  first.depends = $(first) copydata
  export(first.depends)

  DDIR = $$DESTDIR
  win32:DDIR ~= s,/,\\,g
  copydata.commands += $$QMAKE_MKDIR $$quote($$DDIR) $$escape_expand(\\n\\t)

  for(FILE, files) {

    # Replace slashes in paths with backslashes for Windows
    win32:FILE ~= s,/,\\,g

    copydata.commands += $$QMAKE_COPY $$quote($$absolute_path(../../$$TARGET/$$FILE)) $$quote($$DDIR) $$escape_expand(\\n\\t)
  }

  export(copydata.commands)
  QMAKE_EXTRA_TARGETS += first copydata

  export(QMAKE_EXTRA_TARGETS)
}

#== TDP_COPY =======================================================================================
defined(TDP_COPY, var) {
  OTHER_FILES += $$TDP_COPY
  tdpCopy($$TDP_COPY)
}

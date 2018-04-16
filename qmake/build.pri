exists(../../project.inc) {
include(../../project.inc)
}

exists(../../$${TARGET}/dependencies.pri) {
include(../../$${TARGET}/dependencies.pri)
}

# Bring in the dependencies tree
include(parse_dependencies.pri)

for(INCLUDE, INCLUDEPATHS) {
  INCLUDEPATH += $$PWD/../../$${INCLUDE}
}

LIBRARIES = $$reverse(LIBRARIES)
for(LIB, LIBRARIES) {
  !equals(TARGET, $${LIB}){
    LIBS += -l$${LIB}
  }
}

OBJECTS_DIR = ./obj/
MOC_DIR = ./moc/

CONFIG += c++17
DEFINES += TDP_CPP_VERSION=17

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

}


#== Special handling for Windows ===================================================================
else:win32{
DESTDIR = ../lib/
winrt:INCLUDEPATH += $$_PRO_FILE_PWD_/moc/
}


#== Special handling for OSX =======================================================================
else:osx{
DEFINES += TDP_OSX
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib): DESTDIR = ../lib/
}

#== Special handling for iOS =======================================================================
else:iphoneos{
DEFINES += TDP_IOS
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib): DESTDIR = ../lib/
}


#== Everything else ================================================================================
else{
contains(TEMPLATE, app): DESTDIR = ../bin/
contains(TEMPLATE, lib): DESTDIR = ../lib/
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

#== Clang UndefinedBehaviorSanitizer ===============================================================
#CONFIG += tdp_ubsan
tdp_ubsan{
  message("Enabling ubsan!")
  #dnf install libubsan
  QMAKE_CXXFLAGS += -fno-sanitize-recover=undefined
  QMAKE_LFLAGS += -fno-sanitize-recover=undefined
}

#== TDP_COPY =======================================================================================
defined(TDP_COPY, var) {
  OTHER_FILES += $$TDP_COPY
  tdpCopy($$TDP_COPY)
}


### PROJECT_DIR
The project that the top level submodules.pri file is located in.

Found in the following locations:
* GMake - Once in top level Makefile
* CMake - NA see tp_parse_submodules
* QMake - Once in top level .pro file

### TP_BUILD_TYPE
Used to determine what type of GMake build to perform, each different type has a subdirectory in 
```tp_build/gmake/```. The following build types are supported:
* emcc - For Emscripten builds.
* sdcc - For C builds using SDCC, typically only for 8051.
* static - For building static libraries and binaries.
* uc - For C++ microcontroller and Arduino builds.

Found in the following locations:
* GMake - Once in toolchain.pri

### INCLUDEPATHS
This can contain relative or absolute include paths. The build system will add -I to these where 
required.

Found in the following locations:
* All - dependencies.pri should contain the include path for that module.
* All - Top level project.inc can contain platform specific include paths.
* All - project.conf can contain include paths common to all platforms.

### INCLUDEPATH
Avoid using this.

### INCLUDES
Avoid using this. Passed directly into the compiler on GMake builds.

### LIBRARIES
Used to list internal libraries, each module should list itself in its dependencies.pri file.

Found in the following locations:
* All - dependencies.pri should contain the include path for that module.

### LIBRARYPATHS

### LIBS

### TARGET
The name of the app or lib to build.

Found in the following locations:
* All - vars.pri should contain the name of that module.

### TEMPLATE 
The type of thing to build.

Possible values:
* app - Used to build a binary.
* lib - Used to build a library.

Found in the following locations:
* All - vars.pri

### TP_RC
Resource file.

Found in the following locations:
* All - vars.pri

### RESOURCES
Qt resource file.

Found in the following locations:
* All - vars.pri

### SOURCES 
Source files.

Found in the following locations:
* All - vars.pri

### HEADERS
Header files.

Found in the following locations:
* All - vars.pri

### DEFINES
Preprocessor defines.

Found in the following locations:
* All - Top level project.inc
* All - project.conf
* All - dependencies.pri

### QT

### TP_QTPLUGIN

### TP_DEPENDENCIES
Used to find extra dependencies.

Possible values:
* Built in values found in tp_build/dependencies.
  * TP_DEPENDENCIES += filesystem
  * TP_DEPENDENCIES += opengl
* Values provided by other modules.
  * TP_DEPENDENCIES += tp_maps_mobile/dependencies/

Found in the following locations:
* All - dependencies.pri

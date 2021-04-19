## Common Files
### submodules.pri
The submodules.pri file existing in an applications git module and is used to define the list of
modules that the application depends on. It is used by the build system to build dependencies and by
```tpUpdate``` to clone the repos.

An example can be found here:
* [example_maps_sdl2/submodules.pri](https://github.com/tdp-libs/example_maps_sdl2/blob/master/submodules.pri)

### dependencies.pri
The dependencies.pri files exist in all applications and libraries and are used to define the list 
of modules that the app/lib depends on. This forms a tree so a dependency can have its own 
dependecies, these child dependencies will automatically be included and don't need listing 
explicitly.

As well as module dependencies this file also add the include path for the module it is in, and any
external library dependencies.

An example for an application can be found here:
* [example_maps_sdl2/dependencies.pri](https://github.com/tdp-libs/example_maps_sdl2/blob/master/dependencies.pri)

And for a few libraries here:
* [tp_maps_sdl/dependencies.pri](https://github.com/tdp-libs/tp_maps_sdl/blob/master/dependencies.pri)
* [tp_ply/dependencies.pri](https://github.com/tdp-libs/tp_ply/blob/master/dependencies.pri)
* [lib_tinyply/dependencies.pri](https://github.com/tdp-libs/lib_tinyply/blob/master/dependencies.pri)

### project.inc
There are 2 project.inc files, the first is in the application git module and the second is in the 
top level directory. The file in the application is used as a template and is copied into the top 
level directory where it can be modified to suit the system that the program is being built.

The project.inc file is used to configure the build and is where paths to libraries and includes are
set. The reason for copying the file is so that local changes are not accidently check back to git.
If you make a change to the project.inc file that might be useful to other people, comment them out
and add them to the project.inc file in the application git module.

An example can be found here:
* [example_maps_sdl2/project.inc](https://github.com/tdp-libs/example_maps_sdl2/blob/master/project.inc)

### project.conf
This holds settings that are used for builds of an application, it lives in the application git
module. Its not used all that often.

An example can be found here:
* [example_maps_sdl2/project.conf](https://github.com/tdp-libs/example_maps_sdl2/blob/master/project.conf)

### vars.pri
There is one of these in all libraries and applications, its used to list the source and header 
files for that module and it defines if the modules builds an app or lib.

An example can be found here:
* [example_maps_sdl2/vars.pri](https://github.com/tdp-libs/example_maps_sdl2/blob/master/vars.pri)

## QMake Specific Files
There are a few files that need to be there to make the Qt build work correctly, these are just 
boiler plate and should not need modification.

### Top level .pro file
This file lives in the application git module but is copied to the top level directory. It is the 
copied file that is opened in Qt Creator or passed to QMake. This file sets the project dir and
includes ```tp_build/qmake/project_subdirs.pri``` this will parse the project ```submodules.pri```
file and the ```vars.pri``` and ```dependencies.pri``` for each of the submodules.

An example can be found here:
* [example_maps_sdl2/maps_sdl2.pro](https://github.com/tdp-libs/example_maps_sdl2/blob/master/maps_sdl2.pro)

### Module .pro file
Each module also has its own pro file this just includes that modules ```vars.pri``` and
```dependencies.pri``` then includes ```../tp_build/qmake/project_tp.pri``` this then brings in 
everything needed to build the module.

### Internals
All the other internals of the QMake build can be found in here:
* [tp_build/qmake](https://github.com/tdp-libs/tp_build/tree/master/qmake)

### qmake.pri
Some modules need a little more logic to bring in dependencies than the ```dependencies.pri``` file 
can provide, to do this they can references a dependencies directory in their ```dependencies.pri```
file. This directory should contain a qmake.pri file that can contain logic, this file can contain 
any QMake syntax logic. 

For this to work the modules dependencies.pri will need a line like this:
```
TP_DEPENDENCIES += tp_maps/dependencies/
```
And the ```qmake.pri``` file should be something like this:
* [tp_maps/dependencies/qmake.pri](https://github.com/tdp-libs/tp_maps/blob/master/dependencies/qmake.pri)


## CMake Specific Files
As with the Qt build there are a load of boiler plate files needed to make the CMake build work.

### CMakeLists.top
This file lives in the application git module, it will be copied to the top level directory and 
renamed ```CMakeLists.txt```. This is the top level CMake file that you pass into CMake when you 
build. When you create a new application it will need modifying to contain the name of the 
application but apart form that its just boiler plate.

An example can be found here:
* [example_maps_sdl2/CMakeLists.top](https://github.com/tdp-libs/example_maps_sdl2/blob/master/CMakeLists.top)

### CMakeLists.txt
Each module needs a ```CMakeLists.txt``` file, this file just contains boiler plate.

An example can be found here:
* [example_maps_sdl2/CMakeLists.txt](https://github.com/tdp-libs/example_maps_sdl2/blob/master/CMakeLists.txt)

### Internals
All the other internals of the CMake build can be found in here:
* [tp_build/cmake](https://github.com/tdp-libs/tp_build/tree/master/cmake)

### cmake.cmake
This serves the same role as ```qmake.pri``` except for CMake builds.

An example can be found here:
* [tp_maps/dependencies/cmake.cmake](https://github.com/tdp-libs/tp_maps/blob/master/dependencies/cmake.cmake)

## GMake Specific Files
For the Emscripten and microcontroller builds GNU make is used directly instead of CMake. As with 
the other builds there are a number of boiler plate files that need to be in place for this top 
work.

### Makefile.top
This is the top level makefile that is copied to the top level directory and renamed to 
```Makefile```, when you call make this is the first file to be parsed.

An example can be found here:
* [example_maps_emcc/Makefile.top](https://github.com/tdp-libs/example_maps_emcc/blob/master/Makefile.top)

### Makefile
Each library or application module needs to have a ```Makefile```, again this just contains boiler
plate that parses the ```vars.pri``` and ```dependencies.pri``` files.

An example can be found here:
* [example_maps_emcc/Makefile](https://github.com/tdp-libs/example_maps_emcc/blob/master/Makefile)

### Internals
All the other internals of the GMake build can be found in here:
* [tp_build/gmake](https://github.com/tdp-libs/tp_build/tree/master/gmake)

There are sub directories in the gmake folder that contain specializations for each of the target 
platforms these are currently limited to Emscripten and microcontroller builds.
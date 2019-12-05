Modules are used to make part of a build conditional, for example you may want to make an external dependency optional.

## Adding / Enabling A Module
Modules are added to a project by modifying the top level ```project.inc``` file. Simply add the relative path to the module like so:
```
MODULES += path/to/module/
```

## Module Structure
A module is a directory containing a number of files that are included in the build when the module is enabled. The following files are required:
* dependencies.pri
* global_vars.pri
* submodules.pri
* vars.pri
Examples of these files can be found in the [example_module](https://github.com/tdp-libs/tp_build/blob/master/documentation/example_module).

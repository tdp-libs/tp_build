TEMPLATE = subdirs

include(../../project.inc)
include(../../$${PROJECT_DIR}/submodules.pri)

for(SUBPROJECT, SUBPROJECTS) {
  include(../../$${SUBPROJECT}/submodules.pri)
}

include(x_parse_modules_submodules.pri)
include(x_parse_deps.pri)

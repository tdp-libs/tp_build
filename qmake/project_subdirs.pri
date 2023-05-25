TEMPLATE = subdirs

PROJECT_DIR_STR = "PROJECT_DIR = $${PROJECT_DIR}"
write_file($${OUT_PWD}/PROJECT_DIR.pri, PROJECT_DIR_STR)

include(../../project.inc)

exists(../../$${PROJECT_DIR}/project.conf) {
include(../../$${PROJECT_DIR}/project.conf)
}

include(../../$${PROJECT_DIR}/submodules.pri)

for(SUBPROJECT, SUBPROJECTS) {
  include(../../$${SUBPROJECT}/submodules.pri)
}

include(x_parse_modules_submodules.pri)
include(x_parse_deps.pri)

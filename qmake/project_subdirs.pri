TEMPLATE = subdirs

PROJECT_DIR_STR = "PROJECT_DIR = $${PROJECT_DIR}"
write_file($${OUT_PWD}/PROJECT_DIR.pri, PROJECT_DIR_STR)

TP_CONFIG=$$system("bash -c \"echo $TP_CONFIG\"")
isEmpty(TP_CONFIG) {
  exists(../../project.inc) {
    include(../../project.inc)
  }
}else{
  exists(../../$${TP_CONFIG}) {
    include(../../$${TP_CONFIG})
  }
}

exists(../../$${PROJECT_DIR}/project.conf) {
include(../../$${PROJECT_DIR}/project.conf)
}

include(../../$${PROJECT_DIR}/submodules.pri)

for(SUBPROJECT, SUBPROJECTS) {
  include(../../$${SUBPROJECT}/submodules.pri)
}

include(x_parse_modules_submodules.pri)
include(x_parse_deps.pri)

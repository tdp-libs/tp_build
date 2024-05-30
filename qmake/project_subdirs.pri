TEMPLATE = subdirs

GLOBALS_STR = "PROJECT_DIR = $${PROJECT_DIR}"

TP_CONFIG=$$system("bash -c \"echo $TP_CONFIG\"")
isEmpty(TP_CONFIG) {
  exists(../../project.inc) {
    include(../../project.inc)

    PROJECT_INC=$$absolute_path("$$PWD/../../project.inc")
    GLOBALS_STR += "include($${PROJECT_INC})"
  }
}else{
  exists(../../$${TP_CONFIG}) {
    include(../../$${TP_CONFIG})
    PROJECT_INC=$$absolute_path("$$PWD/../../$${TP_CONFIG}")
    GLOBALS_STR += "include($${PROJECT_INC})"
  }
}

PROJECT_ROOT = $$absolute_path("$$PWD/../../")
TP_GIT = $$absolute_path("$$PWD/../../tp_build/tp_git/")

TP_GIT_BRANCH = $$system("bash -c \"cd $${PROJECT_ROOT}/tp_build ; $${TP_GIT}/extract_git_branch.sh\"")
TP_GIT_COMMIT = $$system("bash -c \"cd $${PROJECT_ROOT}/tp_build ; $${TP_GIT}/extract_git_commit.sh\"")
TP_GIT_COMMIT_NUMBER = $$system("bash -c \"cd $${PROJECT_ROOT}/tp_build ; $${TP_GIT}/extract_git_commit_number.sh\"")

GLOBALS_STR += "TP_GIT_BRANCH = $${TP_GIT_BRANCH}"
GLOBALS_STR += "TP_GIT_COMMIT = $${TP_GIT_COMMIT}"
GLOBALS_STR += "TP_GIT_COMMIT_NUMBER = $${TP_GIT_COMMIT_NUMBER}"

write_file($${OUT_PWD}/GLOBALS.pri, GLOBALS_STR)

exists(../../$${PROJECT_DIR}/project.conf) {
include(../../$${PROJECT_DIR}/project.conf)
}

include(../../$${PROJECT_DIR}/submodules.pri)

for(SUBPROJECT, SUBPROJECTS) {
  include(../../$${SUBPROJECT}/submodules.pri)
}

include(x_parse_modules_submodules.pri)
include(x_parse_deps.pri)

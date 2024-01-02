
##Use:
##TP_RC += file.qrc

TP_RC_TOOL_SOURCE = $$absolute_path(../tp_rc/tp_rc.cpp)
TP_RC_TOOL = $$absolute_path($$OUT_PWD/../tpRc)

# tpRc is now built by tp_build/tp_build.pro this means it gets built once and does not trigger a
# relink on every build of any module that has a .qrc file.

tpRc.name = Compiling resources using tpRc
tpRc.input = TP_RC
tpRc.output = $${OUT_PWD}/${QMAKE_FILE_BASE}.cpp
tpRc.commands = $${TP_RC_TOOL} --compile ${QMAKE_FILE_IN} $${OUT_PWD}/${QMAKE_FILE_BASE}.cpp ${QMAKE_FILE_BASE} $${TP_RC_EXCLUDE_FILE}
tpRc.variable_out = SOURCES

# win32{
#   tpRc.depend_command = bash -c grep -hs ^ $${OUT_PWD}/${QMAKE_FILE_BASE}.cpp.dep
# }else{
#   tpRc.depend_command = grep -hs ^ $${OUT_PWD}/${QMAKE_FILE_BASE}.cpp.dep
# }

tpRc.depend_command = $${TP_RC_TOOL} --depend ${QMAKE_FILE_IN} $${OUT_PWD}/${QMAKE_FILE_BASE}.cpp ${QMAKE_FILE_BASE} $${TP_RC_EXCLUDE_FILE}

tpRc.CONFIG = dep_lines

QMAKE_EXTRA_COMPILERS += tpRc

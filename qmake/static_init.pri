
##Use:
##In dependencies.pri
##TP_STATIC_INIT += module_name

contains(TEMPLATE, app){

  TP_STATIC_INIT = $$unique(TP_STATIC_INIT)
  for(SRC, TP_STATIC_INIT) {
    TP_STATIC_INIT_SOURCES += ../$${SRC}/$${SRC}.pro
  }

  tpStaticInit.name = Generate init code
  tpStaticInit.input = TP_STATIC_INIT_SOURCES
  tpStaticInit.depends += $$PWD/../tp_static_init/generate_static_init.sh
  tpStaticInit.depends += $$PWD/../../${QMAKE_FILE_IN_BASE}/inc/${QMAKE_FILE_IN_BASE}/Globals.h
  tpStaticInit.depends += $$PWD/../../${QMAKE_FILE_IN_BASE}/src/Globals.cpp
  tpStaticInit.commands = $$PWD/../tp_static_init/generate_static_init.sh ${QMAKE_FILE_OUT} ${QMAKE_FILE_IN_BASE}
  tpStaticInit.output = ${QMAKE_VAR_OBJECTS_DIR}/${QMAKE_FILE_IN_BASE}_static_init.cpp
  tpStaticInit.clean = ${QMAKE_VAR_OBJECTS_DIR}/${QMAKE_FILE_IN_BASE}_static_init.cpp
  tpStaticInit.variable_out = SOURCES
  QMAKE_EXTRA_COMPILERS += tpStaticInit
}


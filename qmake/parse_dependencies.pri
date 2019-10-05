ITERATIONS = 0 1 2 3 4 5 6 7 8 9
for(a, ITERATIONS) {
  for(DEPENDENCY, DEPENDENCIES) {
    DEPENDENCIES_ += $$PWD/../../$${DEPENDENCY}/dependencies.pri
  }
  DEPENDENCIES =
  for(DEPENDENCY, DEPENDENCIES_) {
    include($${DEPENDENCY})
  }
  DEPENDENCIES_ =
}

TP_DEPENDENCIES = $$unique(TP_DEPENDENCIES)
for(TP_DEPENDENCY, TP_DEPENDENCIES) {
  exists(../../$${TP_DEPENDENCY}/qmake.pri){
    include(../../$${TP_DEPENDENCY}/qmake.pri)
  } else {
    include(../../tp_build/dependencies/$${TP_DEPENDENCY}/qmake.pri)
  }
}


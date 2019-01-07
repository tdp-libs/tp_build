for(MODULE, MODULES) {
  TP_INJECT=
  include(../../$${MODULE}/inject.pri)
  contains(TP_INJECT, $${TARGET}) {
    include(../../$${MODULE}/dependencies.pri)
  }
}


for(MODULE, MODULES) {
  include(../../$${MODULE}/dependencies.pri)

  equals(TEMPLATE, app) {
    include(../../$${MODULE}/vars.pri)
  }
}


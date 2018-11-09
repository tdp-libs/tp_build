for(MODULE, MODULES) {
  include(../../$${MODULE}/submodules.pri)
  #include(../../$${SUBDIR}/dependencies.pri)
  #$${SUBDIR}.subdir = $${SUBDIR}
  #$${SUBDIR}.target = $${SUBDIR}
  #$${SUBDIR}.depends = $${DEPENDENCIES}
}


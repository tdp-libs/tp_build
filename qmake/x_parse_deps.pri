for(SUBDIR, SUBDIRS) {
  DEPENDENCIES =
  include(../../$${SUBDIR}/dependencies.pri)
  $${SUBDIR}.subdir = $${SUBDIR}
  $${SUBDIR}.target = $${SUBDIR}
  $${SUBDIR}.depends = $${DEPENDENCIES}
}


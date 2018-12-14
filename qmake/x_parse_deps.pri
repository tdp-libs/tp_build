
SUBDIRS = $$unique(SUBDIRS)

for(SUBDIR, SUBDIRS) {
  DEPENDENCIES =
  include(../../$${SUBDIR}/dependencies.pri)

  equals(SUBDIR, $${PROJECT_DIR}) {
    for(MODULE, MODULES) {
      include(../../$${MODULE}/dependencies.pri)
    }
  }

  $${SUBDIR}.subdir = $${SUBDIR}
  $${SUBDIR}.target = $${SUBDIR}
  $${SUBDIR}.depends = $${DEPENDENCIES}
}


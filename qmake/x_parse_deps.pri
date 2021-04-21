
SUBDIRS = $$unique(SUBDIRS)

for(SUBDIR, SUBDIRS) {
  DEPENDENCIES =
  include(../../$${SUBDIR}/dependencies.pri)

  for(MODULE, MODULES) {
    TP_INJECT=
    include(../../$${MODULE}/inject.pri)
    contains(TP_INJECT, $${SUBDIR}) {
      include(../../$${MODULE}/dependencies.pri)
    }
  }

  $${SUBDIR}.subdir = $${SUBDIR}
  $${SUBDIR}.target = $${SUBDIR}
  $${SUBDIR}.depends = $${DEPENDENCIES} tp_build
}

SUBDIRS += tp_build


# Copies the given files to the destination directory
defineTest(tpInstall) {
  location = $${1}/
  DESTDIR = $$shadowed($$PWD)
  DESTDIR = $$DESTDIR/../

  tp_libs.path = $${location}lib
  tp_libs.files = $${DESTDIR}lib/*

  tp_bins.path = $${location}bin
  tp_bins.files = $${DESTDIR}bin/*

  INSTALLS += tp_libs tp_bins

  export(tp_libs.path)
  export(tp_libs.files)
  export(tp_bins.path)
  export(tp_bins.files)
  export(INSTALLS)
}

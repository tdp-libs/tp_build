
# Copies the given files to the destination directory
defineTest(tdpInstall) {
  location = $${1}/
  DESTDIR = $$shadowed($$PWD)
  DESTDIR = $$DESTDIR/../

  tdp_libs.path = $${location}lib
  tdp_libs.files = $${DESTDIR}lib/*

  tdp_bins.path = $${location}bin
  tdp_bins.files = $${DESTDIR}bin/*

  INSTALLS += tdp_libs tdp_bins

  export(tdp_libs.path)
  export(tdp_libs.files)
  export(tdp_bins.path)
  export(tdp_bins.files)
  export(INSTALLS)
}

# Copies the given files to the destination directory
#Use:
#TP_COPY += file.xyz
defineTest(tpCopy) {
  files = $$1

  first.depends = $(first) copydata
  export(first.depends)

  DDIR = $$DESTDIR
  win32:DDIR ~= s,/,\\,g
  copydata.commands += $$QMAKE_MKDIR $$quote($$DDIR) $$escape_expand(\\n\\t)

  for(FILE, files) {

    # Replace slashes in paths with backslashes for Windows
    win32:FILE ~= s,/,\\,g

    copydata.commands += $$QMAKE_COPY $$quote($$absolute_path(../../$$TARGET/$$FILE)) $$quote($$DDIR) $$escape_expand(\\n\\t)
  }

  export(copydata.commands)
  QMAKE_EXTRA_TARGETS += first copydata

  export(QMAKE_EXTRA_TARGETS)
}

#== TP_COPY ========================================================================================
defined(TP_COPY, var) {
  OTHER_FILES += $$TP_COPY
  tpCopy($$TP_COPY)
}

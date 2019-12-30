
tp_extract_translations {
  # Wrap the CXX command so that we can access the preprocessor output
  QMAKE_CXX = $$absolute_path(../tp_tr/wrap_cxx.sh) $${QMAKE_CXX} $$absolute_path($$OUT_PWD)

  TP_TR_TOOL_SOURCE = $$absolute_path(../tp_tr/tp_tr.cpp)
  TP_TR_TOOL = $$absolute_path($$OUT_PWD/cc1plus)

  buildtptr.output = $${TP_TR_TOOL}
  buildtptr.target = buildtptr
  buildtptr.commands = $$TP_HOST_CXX -std=gnu++1z -O2 $$TP_TR_TOOL_SOURCE -o $$TP_TR_TOOL
  QMAKE_EXTRA_TARGETS += buildtptr
  PRE_TARGETDEPS += buildtptr
}

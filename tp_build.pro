TARGET = tp_build
TEMPLATE = lib
QT -= core gui widgets

include(qmake/host_cxx.pri)


TP_RC_TOOL_SOURCE = $$absolute_path(tp_rc/tp_rc.cpp)
TP_RC_TOOL = $$absolute_path($$OUT_PWD/../tpRc)

# The old way would build when make was run.
# buildtprc.output = $${TP_RC_TOOL}
# buildtprc.target = buildtprc
# buildtprc.commands = $$TP_HOST_CXX -std=gnu++1z -O2 $$TP_RC_TOOL_SOURCE -o $$TP_RC_TOOL
# PRE_TARGETDEPS += buildtprc
# QMAKE_EXTRA_TARGETS += buildtprc

# The new way builds inside QMake so that we can use it later on in QMake to find deps.
# system($$TP_HOST_CXX -std=gnu++1z -O2 $$TP_RC_TOOL_SOURCE -o $$TP_RC_TOOL)
system($$TP_HOST_CXX -std=gnu++1z -O2 -g -fsanitize=address -fsanitize=undefined -fsanitize-address-use-after-scope -fstack-protector-all $$TP_RC_TOOL_SOURCE -o $$TP_RC_TOOL)

SOURCES += qmake/tp_build.cpp

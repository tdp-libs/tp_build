TARGET = tp_build
TEMPLATE = lib

include(qmake/host_cxx.pri)

TP_RC_TOOL_SOURCE = $$absolute_path(tp_rc/tp_rc.cpp)
TP_RC_TOOL = $$absolute_path($$OUT_PWD/../tpRc)

buildtprc.output = $${TP_RC_TOOL}
buildtprc.target = buildtprc
buildtprc.commands = $$TP_HOST_CXX -std=gnu++1z -O2 $$TP_RC_TOOL_SOURCE -o $$TP_RC_TOOL

PRE_TARGETDEPS += buildtprc
QMAKE_EXTRA_TARGETS += buildtprc

SOURCES += qmake/tp_build.cpp

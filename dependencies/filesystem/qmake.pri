DEFINES += TP_FILESYSTEM

macx {
SLIBS        += boost_system
SLIBS        += boost_filesystem
}
else {
SLIBS        += stdc++fs
}

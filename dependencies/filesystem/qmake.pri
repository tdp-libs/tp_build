DEFINES += TP_FILESYSTEM

macx {
SLIBS        += boost_system
SLIBS        += boost_filesystem
}
else:iphoneos {

}
else {
SLIBS        += stdc++fs
}

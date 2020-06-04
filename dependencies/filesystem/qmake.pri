DEFINES += TP_FILESYSTEM

macx {
  custom_boost {
    # Custom bost config has been specified in project.inc
    # CONFIG += custom_boost
  }else {
    SLIBS        += boost_system
    SLIBS        += boost_filesystem
  }
}

else:iphoneos {

}

else:android {

}

else:win32 {

}

else {
  SLIBS        += stdc++fs
}

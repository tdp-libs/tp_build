
if(WIN32)
  list(APPEND TP_LIBRARIES "libstdc++fs")
  # list(APPEND TP_LIBRARIES "c++fs")
  # list(APPEND TP_LIBRARIES "libc++fs")
else()
  list(APPEND TP_LIBRARIES "-lstdc++fs")
endif()


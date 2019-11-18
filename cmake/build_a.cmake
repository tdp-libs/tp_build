set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-pthread")

function(tp_parse_vars)  
  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" HEADERS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_HEADERS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" SOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_SOURCES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TARGET
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TARGET)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TEMPLATE
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TEMPLATE)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TP_RC
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RC)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_INCLUDEPATHS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARIES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARYPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARYPATHS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" DEFINES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEFINES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_DEPENDENCIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEPENDENCIES)

  string(REPLACE " " ";" TP_INCLUDEPATHS ${TP_INCLUDEPATHS})
  string(STRIP "${TP_INCLUDEPATHS}" TP_INCLUDEPATHS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_INCLUDEPATHS})
    string(FIND "${f}" "/" out)
    if("${out}" EQUAL 0)
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_INCLUDEPATHS "${TP_TMP_LIST}")

  string(REPLACE " " ";" TP_LIBRARYPATHS ${TP_LIBRARYPATHS})
  string(STRIP "${TP_LIBRARYPATHS}" TP_LIBRARYPATHS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_LIBRARYPATHS})
    string(FIND "${f}" "/" out)
    if("${out}" EQUAL 0)
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_LIBRARYPATHS "${TP_TMP_LIST}")

  string(REPLACE " " ";" TP_LIBRARIES ${TP_LIBRARIES})
  string(STRIP "${TP_LIBRARIES}" TP_LIBRARIES)
  string(REPLACE " " ";" TP_LIBS ${TP_LIBS})
  string(STRIP "${TP_LIBS}" TP_LIBS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_LIBRARIES})
    list(APPEND TP_TMP_LIST "${f}")
  endforeach(f)
  foreach(f ${TP_LIBS})
    list(APPEND TP_TMP_LIST "${f}")
  endforeach(f)
  set(TP_LIBRARIES "${TP_TMP_LIST}")

  string(REPLACE " " ";" TP_DEPENDENCIES ${TP_DEPENDENCIES})
  string(STRIP "${TP_DEPENDENCIES}" TP_DEPENDENCIES)
  list(REMOVE_DUPLICATES TP_DEPENDENCIES)
  foreach(f ${TP_DEPENDENCIES})
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
      include("${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
    else()
      include("${CMAKE_CURRENT_LIST_DIR}/../tp_build/dependencies/${f}/cmake.cmake")
    endif()
  endforeach(f)

  list(REVERSE TP_LIBRARIES)
  list(REMOVE_DUPLICATES TP_LIBRARIES)
  list(REVERSE TP_LIBRARIES)

  string(REPLACE " " ";" TP_DEFINES ${TP_DEFINES})
  string(STRIP "${TP_DEFINES}" TP_DEFINES)
  set(TP_TMP_LIST "")
  foreach(f ${TP_DEFINES})
    list(APPEND TP_TMP_LIST "-D${f}")
  endforeach(f)
  set(TP_DEFINES "${TP_TMP_LIST}")

  string(STRIP "${TP_TEMPLATE}" TP_TEMPLATE)

  string(STRIP "${TP_TARGET}" TP_TARGET)

  string(REPLACE " " ";" TP_SOURCES ${TP_SOURCES})
  string(STRIP "${TP_SOURCES}" TP_SOURCES)

  string(REPLACE " " ";" TP_HEADERS ${TP_HEADERS})
  string(STRIP "${TP_HEADERS}" TP_HEADERS)

  add_custom_command(
    OUTPUT  "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    COMMAND g++ -std=gnu++1z -O2 "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp" -o "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp"
  )

  string(REPLACE " " ";" TP_RC ${TP_RC})
  string(STRIP "${TP_RC}" TP_RC)
  foreach(f ${TP_RC})
    get_filename_component(QRC_NAME "${f}" NAME_WE)
    add_custom_command(
      OUTPUT  "${QRC_NAME}.cpp"
      COMMAND "${CMAKE_CURRENT_BINARY_DIR}/tpRc" "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/${QRC_NAME}.cpp"
      DEPENDS "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    )
    list(APPEND TP_SOURCES "${QRC_NAME}.cpp")
  endforeach(f)

  if(APPLE)
    list(APPEND TP_DEFINES -DTP_OSX)
  elseif( ANDROID )
    list(APPEND TP_DEFINES -DTP_ANDROID)
  elseif( UNIX )
  
  endif()

  if(TP_TEMPLATE STREQUAL "lib")
    include_directories(${TP_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_library("${TP_TARGET}" ${TP_SOURCES})
  endif()

  if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
    include_directories(${TP_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_executable("${TP_TARGET}" ${TP_SOURCES})
    target_link_libraries("${TP_TARGET}"  ${TP_LIBRARIES})
  endif()

  if(TP_TEMPLATE STREQUAL "subdirs")
    
  endif()

endfunction() 


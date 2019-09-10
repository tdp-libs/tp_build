set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-pthread")

function(tdp_parse_vars)  
  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_vars.sh" HEADERS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_HEADERS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_vars.sh" SOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_SOURCES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_vars.sh" TARGET
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_TARGET)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_vars.sh" TEMPLATE
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_TEMPLATE)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_vars.sh" TP_RC
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_RC)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_INCLUDEPATHS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_LIBRARIES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" LIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_LIBS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" LIBRARYPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_LIBRARYPATHS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" DEFINES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_DEFINES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" TP_DEPENDENCIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_DEPENDENCIES)

  string(REPLACE " " ";" TDP_INCLUDEPATHS ${TDP_INCLUDEPATHS})
  string(STRIP "${TDP_INCLUDEPATHS}" TDP_INCLUDEPATHS)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_INCLUDEPATHS})
    string(FIND "${f}" "/" out)
    if("${out}" EQUAL 0)
      list(APPEND TDP_TMP_LIST "${f}")
    else()
      list(APPEND TDP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TDP_INCLUDEPATHS "${TDP_TMP_LIST}")

  string(REPLACE " " ";" TDP_LIBRARYPATHS ${TDP_LIBRARYPATHS})
  string(STRIP "${TDP_LIBRARYPATHS}" TDP_LIBRARYPATHS)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_LIBRARYPATHS})
    string(FIND "${f}" "/" out)
    if("${out}" EQUAL 0)
      list(APPEND TDP_TMP_LIST "${f}")
    else()
      list(APPEND TDP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TDP_LIBRARYPATHS "${TDP_TMP_LIST}")

  string(REPLACE " " ";" TDP_LIBRARIES ${TDP_LIBRARIES})
  string(STRIP "${TDP_LIBRARIES}" TDP_LIBRARIES)
  string(REPLACE " " ";" TDP_LIBS ${TDP_LIBS})
  string(STRIP "${TDP_LIBS}" TDP_LIBS)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_LIBRARIES})
    list(APPEND TDP_TMP_LIST "${f}")
  endforeach(f)
  foreach(f ${TDP_LIBS})
    list(APPEND TDP_TMP_LIST "${f}")
  endforeach(f)
  set(TDP_LIBRARIES "${TDP_TMP_LIST}")

  string(REPLACE " " ";" TDP_DEPENDENCIES ${TDP_DEPENDENCIES})
  string(STRIP "${TDP_DEPENDENCIES}" TDP_DEPENDENCIES)
  list(REMOVE_DUPLICATES TDP_DEPENDENCIES)
  foreach(f ${TDP_DEPENDENCIES})
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
      include("${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
    else()
      include("${CMAKE_CURRENT_LIST_DIR}/../tdp_build/dependencies/${f}/cmake.cmake")
    endif()
  endforeach(f)

  list(REVERSE TDP_LIBRARIES)
  list(REMOVE_DUPLICATES TDP_LIBRARIES)
  list(REVERSE TDP_LIBRARIES)

  string(REPLACE " " ";" TDP_DEFINES ${TDP_DEFINES})
  string(STRIP "${TDP_DEFINES}" TDP_DEFINES)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_DEFINES})
    list(APPEND TDP_TMP_LIST "-D${f}")
  endforeach(f)
  set(TDP_DEFINES "${TDP_TMP_LIST}")

  string(STRIP "${TDP_TEMPLATE}" TDP_TEMPLATE)

  string(STRIP "${TDP_TARGET}" TDP_TARGET)

  string(REPLACE " " ";" TDP_SOURCES ${TDP_SOURCES})
  string(STRIP "${TDP_SOURCES}" TDP_SOURCES)

  string(REPLACE " " ";" TDP_HEADERS ${TDP_HEADERS})
  string(STRIP "${TDP_HEADERS}" TDP_HEADERS)

  add_custom_command(
    OUTPUT  "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    COMMAND g++ -std=gnu++1z -O2 "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/tp_rc/tp_rc.cpp" -o "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/tp_rc/tp_rc.cpp"
  )

  string(REPLACE " " ";" TDP_RC ${TDP_RC})
  string(STRIP "${TDP_RC}" TDP_RC)
  foreach(f ${TDP_RC})
    get_filename_component(QRC_NAME "${f}" NAME_WE)
    add_custom_command(
      OUTPUT  "${QRC_NAME}.cpp"
      COMMAND "${CMAKE_CURRENT_BINARY_DIR}/tpRc" "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/${QRC_NAME}.cpp"
      DEPENDS "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/tpRc"
    )
    list(APPEND TDP_SOURCES "${QRC_NAME}.cpp")
  endforeach(f)

  if(APPLE)
    list(APPEND TDP_DEFINES -DTDP_OSX)
  elseif( ANDROID )
    list(APPEND TDP_DEFINES -DTDP_ANDROID)
  elseif( UNIX )
  
  endif()

  if(TDP_TEMPLATE STREQUAL "lib")
    include_directories(${TDP_INCLUDEPATHS})
    link_directories(${TDP_LIBRARYPATHS})
    add_definitions(${TDP_DEFINES})
    add_library("${TDP_TARGET}" ${TDP_SOURCES})
  endif()

  if(TDP_TEMPLATE STREQUAL "app" OR TDP_TEMPLATE STREQUAL "test")
    include_directories(${TDP_INCLUDEPATHS})
    link_directories(${TDP_LIBRARYPATHS})
    add_definitions(${TDP_DEFINES})
    add_executable("${TDP_TARGET}" ${TDP_SOURCES})
    target_link_libraries("${TDP_TARGET}"  ${TDP_LIBRARIES})
  endif()

  if(TDP_TEMPLATE STREQUAL "subdirs")
    
  endif()

endfunction() 


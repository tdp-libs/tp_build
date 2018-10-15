set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_INCLUDEPATHS)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tdp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TDP_LIBRARIES)

  string(REPLACE " " ";" TDP_INCLUDEPATHS ${TDP_INCLUDEPATHS})
  string(STRIP "${TDP_INCLUDEPATHS}" TDP_INCLUDEPATHS)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_INCLUDEPATHS})
    list(APPEND TDP_TMP_LIST "../${f}")
  endforeach(f)
  set(TDP_INCLUDEPATHS "${TDP_TMP_LIST}")

  string(REPLACE " " ";" TDP_LIBRARIES ${TDP_LIBRARIES})
  string(STRIP "${TDP_LIBRARIES}" TDP_LIBRARIES)
  set(TDP_TMP_LIST "")
  foreach(f ${TDP_LIBRARIES})
    list(APPEND TDP_TMP_LIST "${f}")
  endforeach(f)
  set(TDP_LIBRARIES "${TDP_TMP_LIST}")

  string(STRIP "${TDP_TEMPLATE}" TDP_TEMPLATE)

  string(STRIP "${TDP_TARGET}" TDP_TARGET)

  string(REPLACE " " ";" TDP_SOURCES ${TDP_SOURCES})
  string(STRIP "${TDP_SOURCES}" TDP_SOURCES)

  string(REPLACE " " ";" TDP_HEADERS ${TDP_HEADERS})
  string(STRIP "${TDP_HEADERS}" TDP_HEADERS)

  if(TDP_TEMPLATE STREQUAL "lib")
    include_directories(${TDP_INCLUDEPATHS})
    add_library("${TDP_TARGET}" ${TDP_SOURCES})
  endif()

  if(TDP_TEMPLATE STREQUAL "app")
    include_directories(${TDP_INCLUDEPATHS})
    add_executable("${TDP_TARGET}" ${TDP_SOURCES})
    target_link_libraries("${TDP_TARGET}"  ${TDP_LIBRARIES})
  endif()

  if(TDP_TEMPLATE STREQUAL "subdirs")
    
  endif()

endfunction() 


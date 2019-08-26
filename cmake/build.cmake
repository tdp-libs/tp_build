function(tdp_parse_submodules directory)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/tdp_build/cmake/extract_submodules.sh" SUBPROJECTS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${directory}"
                  OUTPUT_VARIABLE TDP_SUBPROJECTS)

  string(REPLACE " " ";" TDP_SUBPROJECTS ${TDP_SUBPROJECTS})
  string(STRIP "${TDP_SUBPROJECTS}" TDP_SUBPROJECTS)

  set(TDP_SUBDIRS "")
  foreach(subproject ${TDP_SUBPROJECTS})
    set(TDP_SUBDIRS_TMP "")
    execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/tdp_build/cmake/extract_submodules.sh" SUBDIRS
                    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${subproject}"
                    OUTPUT_VARIABLE TDP_SUBDIRS_TMP)

    string(REPLACE " " ";" TDP_SUBDIRS_TMP ${TDP_SUBDIRS_TMP})
    string(STRIP "${TDP_SUBDIRS_TMP}" TDP_SUBDIRS_TMP)

    foreach(subdir ${TDP_SUBDIRS_TMP})
      list(APPEND TDP_SUBDIRS ${subdir})
    endforeach()
  endforeach()

  set(TDP_SUBDIRS_TMP "")
  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/tdp_build/cmake/extract_submodules.sh" SUBDIRS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${directory}"
                  OUTPUT_VARIABLE TDP_SUBDIRS_TMP)

  string(REPLACE " " ";" TDP_SUBDIRS_TMP ${TDP_SUBDIRS_TMP})
  string(STRIP "${TDP_SUBDIRS_TMP}" TDP_SUBDIRS_TMP)

  foreach(subdir ${TDP_SUBDIRS_TMP})
    list(APPEND TDP_SUBDIRS ${subdir})
  endforeach()

  list(REMOVE_DUPLICATES TDP_SUBDIRS)

  foreach(subdir ${TDP_SUBDIRS})
    add_subdirectory(${subdir})
  endforeach()

  set(TDP_TEST_TARGETS "")
  set(TDP_TESTS "")
  foreach(subdir ${TDP_SUBDIRS})
    set(TDP_TEMPLATE "")
    execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/tdp_build/cmake/extract_vars.sh" TEMPLATE
                    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${subdir}"
                    OUTPUT_VARIABLE TDP_TEMPLATE)
    string(STRIP "${TDP_TEMPLATE}" TDP_TEMPLATE)
    if(TDP_TEMPLATE STREQUAL "test")
      set(TDP_TESTS "${TDP_TESTS}./${subdir}/${subdir}\n")
      list(APPEND TDP_TEST_TARGETS "${subdir}")
    endif()
  endforeach()

  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/tests.txt" "${TDP_TESTS}")

  configure_file("${CMAKE_CURRENT_LIST_DIR}/tdp_build/tp_test/run_tests.sh" 
                 "${CMAKE_CURRENT_BINARY_DIR}/run_tests.sh" 
                 COPYONLY)

  add_custom_target(tests
                    COMMAND "${CMAKE_CURRENT_BINARY_DIR}/run_tests.sh"
                    DEPENDS "${TDP_TEST_TARGETS}"
                    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
endfunction()


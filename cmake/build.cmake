function(tp_parse_submodules directory)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/tp_build/cmake/extract_submodules.sh" SUBPROJECTS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${directory}"
                  OUTPUT_VARIABLE TP_SUBPROJECTS
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  set(TP_SUBDIRS "")

  if(NOT "${TP_SUBPROJECTS}" STREQUAL "")
    string(REPLACE " " ";" TP_SUBPROJECTS ${TP_SUBPROJECTS})
    string(STRIP "${TP_SUBPROJECTS}" TP_SUBPROJECTS)

    foreach(subproject ${TP_SUBPROJECTS})
      set(TP_SUBDIRS_TMP "")
      execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/tp_build/cmake/extract_submodules.sh" SUBDIRS
                      WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${subproject}"
                      OUTPUT_VARIABLE TP_SUBDIRS_TMP
                      OUTPUT_STRIP_TRAILING_WHITESPACE)

      if(NOT "${TP_SUBDIRS_TMP}" STREQUAL "")
        string(REPLACE " " ";" TP_SUBDIRS_TMP ${TP_SUBDIRS_TMP})
        string(STRIP "${TP_SUBDIRS_TMP}" TP_SUBDIRS_TMP)

        foreach(subdir ${TP_SUBDIRS_TMP})
          list(APPEND TP_SUBDIRS ${subdir})
        endforeach()
      endif()
    endforeach()
  endif()

  set(TP_SUBDIRS_TMP "")

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/tp_build/cmake/extract_submodules.sh" SUBDIRS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${directory}"
                  OUTPUT_VARIABLE TP_SUBDIRS_TMP
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(NOT "${TP_SUBDIRS_TMP}" STREQUAL "")
    string(REPLACE " " ";" TP_SUBDIRS_TMP ${TP_SUBDIRS_TMP})
    string(STRIP "${TP_SUBDIRS_TMP}" TP_SUBDIRS_TMP)

    foreach(subdir ${TP_SUBDIRS_TMP})
      list(APPEND TP_SUBDIRS ${subdir})
    endforeach()
  endif()

  list(REMOVE_DUPLICATES TP_SUBDIRS)

  foreach(subdir ${TP_SUBDIRS})
    add_subdirectory(${subdir})
  endforeach()

  set(TP_TEST_TARGETS "")
  set(TP_TESTS "")
  foreach(subdir ${TP_SUBDIRS})
    set(TP_TEMPLATE "")
    execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/tp_build/cmake/extract_vars.sh" TEMPLATE
                    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${subdir}"
                    OUTPUT_VARIABLE TP_TEMPLATE
                    OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(STRIP "${TP_TEMPLATE}" TP_TEMPLATE)
    if(TP_TEMPLATE STREQUAL "test")
      set(TP_TESTS "${TP_TESTS}./${subdir}/${subdir}\n")
      list(APPEND TP_TEST_TARGETS "${subdir}")
    endif()
  endforeach()

  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/tests.txt" "${TP_TESTS}")

  configure_file("${CMAKE_CURRENT_LIST_DIR}/tp_build/tp_test/run_tests.sh" 
                 "${CMAKE_CURRENT_BINARY_DIR}/run_tests.sh" 
                 COPYONLY)

  add_custom_target(tests
                    COMMAND "${CMAKE_CURRENT_BINARY_DIR}/run_tests.sh"
                    DEPENDS "${TP_TEST_TARGETS}"
                    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
endfunction()


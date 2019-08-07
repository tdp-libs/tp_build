enable_testing()
add_custom_target(check
        COMMAND env CTEST_OUTPUT_ON_FAILURE=1 GTEST_COLOR=1 ${CMAKE_CTEST_COMMAND})

function(tdp_parse_submodules directory)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/tdp_build/cmake/extract_submodules.sh" SUBDIRS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/${directory}"
                  OUTPUT_VARIABLE TDP_SUBDIRS)

  string(REPLACE " " ";" TDP_SUBDIRS ${TDP_SUBDIRS})
  string(STRIP "${TDP_SUBDIRS}" TDP_SUBDIRS)

  foreach(subdir ${TDP_SUBDIRS})
    add_subdirectory(${subdir})
  endforeach()

endfunction() 

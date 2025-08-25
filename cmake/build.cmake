include(tp_build/cmake/build_a.cmake)

function(tp_parse_submodules)

  # default standard
  set(CMAKE_CXX_STANDARD 20)

  # overwrite default
  if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(CMAKE_CXX_STANDARD 23)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_STANDARD 20)
  elseif(EMSCRIPTEN)
    set(CMAKE_CXX_STANDARD 20)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_CXX_STANDARD 20)
  endif()

  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS OFF)

  if(UNIX)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
  endif()

  message(STATUS "Setting compiler to C++${CMAKE_CXX_STANDARD} standard")

  # to ease debug in release for MSVC removing optimisation for RelWithDebInfo
  if(MSVC)
    string(REPLACE "/Ob1" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
    string(REPLACE "/O2" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
    string(REPLACE "/Ob1" "" CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_C_FLAGS_RELWITHDEBINFO})
    string(REPLACE "/O2" "" CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_C_FLAGS_RELWITHDEBINFO})
    string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO " -DDEBUG_WITH_REL_INFO" )
  endif()

  # extract top project dir from global settings file
  # searching config file
  string(REPLACE "\\" "/" TP_CONFIG_PATH "$ENV{TP_CONFIG}")
  if(NOT TP_CONFIG_PATH)
      message(FATAL_ERROR "TP_CONFIG environmental variable not found!")
  endif()

  file(GLOB TP_CONFIG_PATH "${TP_CONFIG_PATH}")
  if(NOT TP_CONFIG_PATH)
      message(FATAL_ERROR "Config file was not found. Please, check or set TP_CONFIG=$ENV{TP_CONFIG} environmental variable!")
  endif()
  message(STATUS "Reading config file from: ${TP_CONFIG_PATH}")
  list(GET TP_CONFIG_PATH 0 TP_CONFIG_PATH)
  extract_var_value_pair("${TP_CONFIG_PATH}" "TP_TMP_")

  # extract subprojects from top project
  set(PROJECT_DIR ${TP_TMP_PROJECT_DIR})
  message(STATUS "PROJECT_DIR: ${PROJECT_DIR}")

  extract_var_value_pair("${CMAKE_CURRENT_LIST_DIR}/${PROJECT_DIR}/submodules.pri" "TP_TMP_")
  set(TP_SUBPROJECTS "${TP_TMP_SUBPROJECTS}")

  if(TP_SUBPROJECTS)
    set(TP_SUBDIRS "${TP_SUBPROJECTS}")

    # extract dependencies for all subprojects
    foreach(subproject ${TP_SUBPROJECTS})
      set(TP_TMP_SUBDIRS "")

      if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${subproject}/submodules.pri")
        extract_var_value_pair("${CMAKE_CURRENT_LIST_DIR}/${subproject}/submodules.pri" "TP_TMP_")
      endif()

      list(APPEND TP_SUBDIRS "${TP_TMP_SUBDIRS}")
    endforeach()
  endif()

  set(TP_SUBDIRS_TMP "")
  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${PROJECT_DIR}/submodules.pri")
    extract_var_value_pair("${CMAKE_CURRENT_LIST_DIR}/${PROJECT_DIR}/submodules.pri" "TP_TMP_")
  endif()
  list(APPEND TP_SUBDIRS "${TP_TMP_SUBDIRS}")

  list(REMOVE_DUPLICATES TP_SUBDIRS)

  execute_process(COMMAND git rev-parse --symbolic-full-name --abbrev-ref HEAD
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_BRANCH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND git rev-parse HEAD
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_COMMIT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND git rev-list --count HEAD
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_COMMIT_NUMBER
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  message(STATUS "BUILDING:
    BRANCH: ${TP_GIT_BRANCH}
    COMMIT: ${TP_GIT_COMMIT}
    COMMIT_NUMBER: ${TP_GIT_COMMIT_NUMBER}")

  foreach(subdir ${TP_SUBDIRS})
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${subdir}/CMakeLists.txt")
      message(STATUS "adding target: ${subdir}")
      add_subdirectory(${subdir})
    endif()
  endforeach()

  set(TP_TEST_TARGETS "")
  set(TP_TESTS "")
  foreach(subdir ${TP_SUBDIRS})
    set(TP_TEMPLATE "")

    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${subdir}/vars.pri")
      extract_var_value_pair("${CMAKE_CURRENT_LIST_DIR}/${subdir}/vars.pri" "TP_TMP_")
    endif()
    list(APPEND TP_TEST_TARGETS ${TP_TMP_TEMPLATE})
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


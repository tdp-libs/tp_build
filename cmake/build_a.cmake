# Function to read a file and set name=value pairs as CMake variables
# it receives two lists arguments of the same size:
#    filename_list - list of file names to extract paramters
#    prefix_list - list of prefixes for each file which will be added to any variable found in the file
# If your prefix for given file defined as "MY_PREFIX_" then pair NAME[+]=VALUE in the file
# will be translated to cmake variable MY_PREFIX_NAME=VALUE
# i.e.: records in file
#   RELATIVE_SYSTEM_INCLUDEPATHS += omi/some/add_subdirectory
#   RELATIVE_SYSTEM_INCLUDEPATHS += omi/some/add_subdirectory2
# will results to MY_PREFIX_RELATIVE_SYSTEM_INCLUDEPATHS = "omi/some/add_subdirectory;omi/some/add_subdirectory2"
# variable.

function(extract_var_value_pair filename_list prefix_list)

  # For documentation of the supported variabls see:
  # https://github.com/tdp-libs/tp_build/blob/master/documentation/variables.md

  set(varname_list
    INCLUDEPATHS SYSTEM_INCLUDEPATHS RELATIVE_SYSTEM_INCLUDEPATHS
    LIBRARIES TP_FRAMEWORKS LIBS SLIBS LIBRARYPATHS DEFINES
    TP_DEPENDENCIES DEPENDENCIES TP_STATIC_INIT QT QTPLUGIN
    CFLAGS CXXFLAGS LFLAGS

    HEADERS SOURCES TP_RC RESOURCES TARGET TEMPLATE

    PROJECT_DIR SUBPROJECTS SUBDIRS
  )

    #foreach(filename_arg vpref IN ZIP_LISTS filename_list prefix_list)

    # here old style for iterating over two lists
    list(LENGTH filename_list num_items)
    math(EXPR num_items "${num_items}-1")
    foreach(index RANGE ${num_items})
      list(GET filename_list ${index} filename_arg)
      list(GET prefix_list ${index} vpref)

      # Read the file content
      file(READ "${filename_arg}" FILE_CONTENT)

      string(REGEX REPLACE "[\r\n]+" ";" PAIRS "${FILE_CONTENT}")

      # Iterate over the pairs and set variables
      foreach(PAIR ${PAIRS})

        string(REGEX MATCH "^[\t ]*([^#\+ \t]+)[\t ]*(\\+?=)[\t ]*\"?([^\"]*)\"?[\t ]*$" _ ${PAIR})

        if(CMAKE_MATCH_COUNT EQUAL 3 )

          set(VARNAME "${CMAKE_MATCH_1}")
          set(VARVALUE "${CMAKE_MATCH_3}")
          string(STRIP ${VARNAME} VARNAME)
          string(STRIP ${VARVALUE} VARVALUE)

          if (VARNAME IN_LIST varname_list)
            list(APPEND ${vpref}${VARNAME} ${VARVALUE})
          endif()

        endif()
      endforeach()

      foreach(varname ${varname_list})
        if( ${vpref}${varname} )
          set(${vpref}${varname}  "${${vpref}${varname}}" PARENT_SCOPE)
        endif()
      endforeach()

    endforeach()

endfunction()


# For documentation of the supported variabls see:
# https://github.com/tdp-libs/tp_build/blob/master/documentation/variables.md
function(tp_parse_vars)

  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/vars.pri")    
    list(APPEND files_to_scan "${CMAKE_CURRENT_LIST_DIR}/vars.pri")
    list(APPEND vpref_list "VAR_TP_")
  endif()

  # add global settings file
  string(REPLACE "\\" "/" TP_CONFIG_PATH "$ENV{TP_CONFIG}")
  if(NOT IS_ABSOLUTE ${TP_CONFIG_PATH})
    set(TP_CONFIG_PATH "${CMAKE_SOURCE_DIR}/${TP_CONFIG_PATH}")
  endif()
  if(NOT EXISTS "${TP_CONFIG_PATH}")
    message(FATAL_ERROR "Config file was not found. Please set TP_CONFIG environmental variable!")
  endif()
  list(APPEND files_to_scan "${TP_CONFIG_PATH}")
  list(APPEND vpref_list "TP_")

  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/dependencies.pri")
    list(APPEND files_to_scan "${CMAKE_CURRENT_LIST_DIR}/dependencies.pri")
    list(APPEND vpref_list "TP_")
  endif()
  extract_var_value_pair("${files_to_scan}" "${vpref_list}")

  execute_process(COMMAND "C:/Program Files/Git/bin/bash.exe" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_git/extract_git_branch.sh"
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_BRANCH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND "C:/Program Files/Git/bin/bash.exe" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_git/extract_git_commit.sh"
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_COMMIT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND "C:/Program Files/Git/bin/bash.exe" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_git/extract_git_commit_number.sh"
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_COMMIT_NUMBER
                  OUTPUT_STRIP_TRAILING_WHITESPACE)


  #== INCLUDEPATHS =================================================================================
  set(TP_TMP_LIST "")
  foreach(f ${TP_INCLUDEPATHS})
    if(IS_ABSOLUTE "${f}")
      string(STRIP "${f}" f)
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_INCLUDEPATHS "${TP_TMP_LIST}")

  #== SYSTEM_INCLUDEPATHS ==========================================================================
  set(TP_TMP_LIST "")
  foreach(f ${TP_SYSTEM_INCLUDEPATHS})
   string(STRIP "${f}" f)
   if(IS_ABSOLUTE "${f}")
     list(APPEND TP_TMP_LIST "${f}")
   else()
     list(APPEND TP_TMP_LIST "../${f}")
   endif()
  endforeach(f)
  set(TP_SYSTEM_INCLUDEPATHS "${TP_TMP_LIST}")


  #== RELATIVE_SYSTEM_INCLUDEPATHS =================================================================
  set(TP_TMP_LIST "")
  foreach(f ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    string(STRIP "${f}" f)
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_RELATIVE_SYSTEM_INCLUDEPATHS "${TP_TMP_LIST}")


  #== LIBRARYPATHS =================================================================================
  set(TP_TMP_LIST "")
  foreach(f ${TP_LIBRARYPATHS})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_LIBRARYPATHS "${TP_TMP_LIST}")


  #== LIBRARIES ====================================================================================
  macro(clean_and_add_libraries PARTS_ARG)
    if(NOT "${PARTS_ARG}" STREQUAL "")
      string(STRIP "${PARTS_ARG}" PARTS)
      if(NOT "${PARTS}" STREQUAL "")
        foreach(f ${PARTS})
          string(STRIP "${f}" f)
          string(REGEX REPLACE "^\-l" ""  f ${f})
          list(APPEND TP_TMP_LIST "${f}")
        endforeach(f)
      endif()
    endif()
  endmacro()

  set(TP_TMP_LIST "")
  clean_and_add_libraries("${TP_LIBRARIES}")
  clean_and_add_libraries("${TP_LIBS}")
  clean_and_add_libraries("${TP_SLIBS}")
  set(TP_LIBRARIES "${TP_TMP_LIST}")

  string(STRIP "${TP_TP_DEPENDENCIES}" TP_TP_DEPENDENCIES)
  if(NOT TP_TP_DEPENDENCIES STREQUAL "")
    list(REMOVE_DUPLICATES TP_TP_DEPENDENCIES)
    foreach(f ${TP_TP_DEPENDENCIES})
      if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
        include("${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
      else()
        include("${CMAKE_CURRENT_LIST_DIR}/../tp_build/dependencies/${f}/cmake.cmake")
      endif()
    endforeach(f)
  endif()

  # list(REVERSE TP_LIBRARIES)
  list(REMOVE_DUPLICATES TP_LIBRARIES)
  # list(REVERSE TP_LIBRARIES)

  #== FRAMEWORKS ===================================================================================
  if(APPLE)
    macro(clean_and_add_frameworks PARTS_ARG)
      if(NOT "${PARTS_ARG}" STREQUAL "")
        string(STRIP "${PARTS_ARG}" PARTS)
        if(NOT "${PARTS}" STREQUAL "")
          string(REGEX REPLACE "\n$" "" PARTS "${PARTS}")
          string(REGEX REPLACE "\r$" "" PARTS "${PARTS}")
          foreach(f ${PARTS})
            list(APPEND TP_LIBRARIES "-framework ${f}")
          endforeach(f)
        endif()
      endif()
    endmacro()

    clean_and_add_frameworks("${TP_FRAMEWORKS}")
  endif()

  #== DEFINES ======================================================================================
  macro(clean_and_add_defines PARTS_ARG)
    set(PARTS ${PARTS_ARG})
    foreach(f ${PARTS})
      string(FIND "${f}" "-" out)
      if("${out}" EQUAL 0)
        list(APPEND TP_TMP_LIST "${f}")
      else()
        list(APPEND TP_TMP_LIST "-D${f}")
      endif()
    endforeach(f)
  endmacro()

  set(TP_TMP_LIST "")
  list(APPEND TP_TMP_LIST "-DTP_GIT_BRANCH=${TP_GIT_BRANCH}")
  list(APPEND TP_TMP_LIST "-DTP_GIT_COMMIT=${TP_GIT_COMMIT}")
  list(APPEND TP_TMP_LIST "-DTP_GIT_COMMIT_NUMBER=${TP_GIT_COMMIT_NUMBER}")
  clean_and_add_defines("${VAR_TP_DEFINES}")
  set(VAR_TP_DEFINES "${TP_TMP_LIST}")

  set(TP_TMP_LIST "")
  clean_and_add_defines("${TP_DEFINES}")
  set(TP_DEFINES "${TP_TMP_LIST}")

  if(IOS)
    list(APPEND TP_DEFINES -DTP_IOS)
  elseif(APPLE)
    list(APPEND TP_DEFINES -DTP_OSX)
  elseif(ANDROID)
    list(APPEND TP_DEFINES -DTP_ANDROID)
  elseif(UNIX)
    list(APPEND TP_DEFINES -DTP_LINUX)
    set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-pthread")
    list(APPEND TP_LIBRARIES "pthread")
  elseif(WIN32)
    list(APPEND TP_DEFINES
      -DTP_WIN32
      -DTP_WIN32_STATIC
      -DTP_CPP_VERSION=17
    )
    if(MSVC)
      list(APPEND TP_DEFINES
        -DTP_WIN32_MSVC
        -D_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS # suppress warning on templates
        -DTP_WIN32_STATIC
      )
      add_compile_options("/std:c++17"  "/bigobj")    # Win32 issue in exprtk.hpp

      #suppress warnings on missing _WIN32_WINNT=...
      macro(get_win_hex outvar)
        string(REGEX MATCH "^([0-9]+)\\.([0-9]+)" ${outvar} ${CMAKE_SYSTEM_VERSION})
        math(EXPR ${outvar} "(${CMAKE_MATCH_1} << 8) + ${CMAKE_MATCH_2}" OUTPUT_FORMAT HEXADECIMAL)
      endmacro()

      if(WIN32)
        get_win_hex(winver)
        add_compile_definitions(_WIN32_WINNT=${winver})
      endif()

    endif()
  endif()


  #== TP RESOURCES =================================================================================
  if(WIN32)
    set(TP_RC_CMD "${CMAKE_CURRENT_BINARY_DIR}/tpRc.exe")
    add_custom_command(
      OUTPUT  "${TP_RC_CMD}"
      COMMAND cl /EHsc /std:c++17 "/Fe\"${TP_RC_CMD}\"" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp"
      DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp"
    )
  else()
    if(APPLE)
      SET(HOST_CXX env -i clang++)
    else()
      SET(HOST_CXX g++)
    endif()
    
    set(TP_RC_CMD "${CMAKE_CURRENT_BINARY_DIR}/tpRc")
    add_custom_command(
      OUTPUT  "${TP_RC_CMD}"
      COMMAND ${HOST_CXX} -std=gnu++1z -O2 "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp" -o "${TP_RC_CMD}"
      DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_rc/tp_rc.cpp"
    )
  endif()

  if(NOT "${VAR_TP_TP_RC}" STREQUAL "")
    string(STRIP "${VAR_TP_TP_RC}" VAR_TP_TP_RC)
    foreach(f ${VAR_TP_TP_RC})
      get_filename_component(QRC_NAME "${f}" NAME_WE)
      add_custom_command(
        OUTPUT  "${QRC_NAME}.cpp"
        COMMAND "${TP_RC_CMD}" --compile "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/${QRC_NAME}.cpp" ${QRC_NAME}
        DEPENDS "${CMAKE_CURRENT_LIST_DIR}/${f}" "${TP_RC_CMD}"
      )
      list(APPEND VAR_TP_SOURCES "${QRC_NAME}.cpp")
    endforeach(f)
  endif()

  #== STATIC_INIT ==================================================================================
  if(VAR_TP_TEMPLATE STREQUAL "app" OR VAR_TP_TEMPLATE STREQUAL "test")
    if(NOT "${TP_TP_STATIC_INIT}" STREQUAL "")
      string(STRIP "${TP_TP_STATIC_INIT}" TP_TP_STATIC_INIT)
      foreach(f ${TP_TP_STATIC_INIT})
        add_custom_command(
          OUTPUT  "${f}.cpp"
          COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_static_init/generate_static_init.sh" "${f}.cpp" ${f}
          DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../${f}/inc/${f}/Globals.h" "${CMAKE_CURRENT_LIST_DIR}/../${f}/src/Globals.cpp" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_static_init/generate_static_init.sh"
        )
        list(APPEND VAR_TP_SOURCES "${f}.cpp")
      endforeach(f)
    endif()
  endif()

  # adding extra files to see them in qt creator
  file(GLOB PRI_FILES RELATIVE "${CMAKE_CURRENT_LIST_DIR}" vars.pri dependencies.pri dependencies/cmake.cmake CMakeLists.top)
  list(APPEND VAR_TP_SOURCES "${PRI_FILES}")

  #== QT ===========================================================================================
  if(TP_QT)
    list(REMOVE_DUPLICATES TP_QT)  
    if(TP_QT)

      find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
      set(QtVer Qt${QT_VERSION_MAJOR})

      if(QT_STATIC)
        list(APPEND TP_DEFINES -DTP_QT_STATIC)
      endif()
  
      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      # As moc files are generated in the binary dir, tell CMake
      # to always look for includes there:
      set(CMAKE_INCLUDE_CURRENT_DIR ON)

      foreach(f ${TP_QT})
        if(f STREQUAL "core")
          find_package(${QtVer} REQUIRED COMPONENTS Core)
          list(APPEND TP_QT_MODULES "${QtVer}::Core")
  
        elseif(f STREQUAL "gui")
          find_package(${QtVer} REQUIRED COMPONENTS Gui)
          find_package(${QtVer} REQUIRED COMPONENTS OpenGLWidgets)
          list(APPEND TP_QT_MODULES "${QtVer}::Gui")
          list(APPEND TP_QT_MODULES "${QtVer}::OpenGLWidgets")
  
        elseif(f STREQUAL "widgets")
          find_package(${QtVer} REQUIRED COMPONENTS Widgets)
          list(APPEND TP_QT_MODULES "${QtVer}::Widgets")
  
          if(UNIX AND QT_STATIC)
            #Remember that you need this somewhere in your application.
            # Q_IMPORT_PLUGIN(QXcbIntegrationPlugin)
            # Q_IMPORT_PLUGIN(QXcbGlxIntegrationPlugin)

            get_target_property(tmp_loc ${QT_VERSION_MAJOR}::QXcbGlxIntegrationPlugin LOCATION)
            list(APPEND TP_LIBRARIES "${tmp_loc}")
            list(APPEND TP_LIBRARIES "${QT_VERSION_MAJOR}${Gui_PLUGINS}")
          endif()
  
          if(WIN32 AND QT_STATIC)
            #Remember that you need this somewhere in your application.
            # Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)

            get_target_property(tmp_loc ${QtVer}::QWindowsIntegrationPlugin LOCATION)
            list(APPEND TP_LIBRARIES "${tmp_loc}")
            list(APPEND TP_LIBRARIES "${QtVer}${Gui_PLUGINS}")
          endif()
  
        elseif(f STREQUAL "opengl")
          find_package(${QtVer} REQUIRED COMPONENTS OpenGL)
          list(APPEND TP_QT_MODULES "${QtVer}::OpenGL")
        endif()
      endforeach(f)
  
      if(NOT "${TP_QTPLUGIN}" STREQUAL "")
        string(STRIP "${TP_QTPLUGIN}" TP_QTPLUGIN)
        list(REMOVE_DUPLICATES TP_QTPLUGIN)
        if(TP_QTPLUGIN AND QT_STATIC)
          foreach(f ${TP_QTPLUGIN})
            if(f STREQUAL "qpng" AND TARGET "${QtVer}::QPngPlugin")
              get_target_property(tmp_loc ${QtVer}::QPngPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qjpeg" AND TARGET "${QtVer}::QJpegPlugin")
              get_target_property(tmp_loc "${QtVer}::QJpegPlugin" LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qbmp" AND TARGET "${QtVer}::QBmpPlugin")
              get_target_property(tmp_loc ${QtVer}::QBmpPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qgif" AND TARGET "${QtVer}::QGifPlugin")
              get_target_property(tmp_loc ${QtVer}::QGifPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            endif()
          endforeach(f)
        endif()
      endif()
  
      #Qt4
      set_property(DIRECTORY PROPERTY QT_VERSION_MAJOR ${QT_VERSION_MAJOR})
      set_property(DIRECTORY PROPERTY QT_VERSION_MINOR ${QT_VERSION_MINOR})
  
      #Qt5
      set_property(DIRECTORY PROPERTY Qt5Core_VERSION_MAJOR ${Qt5Core_VERSION_MAJOR})
      set_property(DIRECTORY PROPERTY Qt5Core_VERSION_MINOR ${Qt5Core_VERSION_MINOR})
  
      #Qt6
      set_property(DIRECTORY PROPERTY Qt6Core_VERSION_MAJOR ${Qt6Core_VERSION_MAJOR})
      set_property(DIRECTORY PROPERTY Qt6Core_VERSION_MINOR ${Qt6Core_VERSION_MINOR})
    endif()
  endif()

  # to see debug messages about specific target set the proper target name (normally is off)
  if(VAR_TP_TARGET STREQUAL "off_lib_glm")

    message(STATUS  "QT_VERSION_MAJOR ${VAR_TP_TARGET} ${QT_VERSION_MAJOR}")
    message(STATUS  "-----------------------------------------")

    message(STATUS "TP_QT_MODULES ${VAR_TP_TARGET} ${TP_QT_MODULES}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_QT ${VAR_TP_TARGET} ${TP_QT}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_DEPENDENCIES ${VAR_TP_TARGET} ${TP_DEPENDENCIES}")
    message(STATUS  "-----------------------------------------")

    message(STATUS "VAR_TP_TEMPLATE ${VAR_TP_TARGET} ${VAR_TP_TEMPLATE}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_LIBRARIES ${VAR_TP_TARGET} ${TP_LIBRARIES}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_LIBRARYPATHS ${VAR_TP_TARGET} ${TP_LIBRARYPATHS}")
    message(STATUS  "-----------------------------------------")

    message(STATUS "TP_INCLUDEPATHS ${VAR_TP_TARGET} ${TP_INCLUDEPATHS}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_SYSTEM_INCLUDEPATHS ${VAR_TP_TARGET} ${TP_SYSTEM_INCLUDEPATHS}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "TP_RELATIVE_SYSTEM_INCLUDEPATHS ${VAR_TP_TARGET} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS}")
    message(STATUS  "-----------------------------------------")

    message(STATUS "VAR_TP_SOURCES ${VAR_TP_TARGET} ${VAR_TP_SOURCES}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "VAR_TP_HEADERS ${VAR_TP_TARGET} ${VAR_TP_HEADERS}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "VAR_TP_RESOURCES ${VAR_TP_TARGET} ${VAR_TP_RESOURCES}")
    message(STATUS  "-----------------------------------------")

    message(STATUS "TP_DEFINES ${TP_DEFINES} ${TP_DEFINES}")
    message(STATUS  "-----------------------------------------")
    message(STATUS "VAR_TP_DEFINES ${VAR_TP_DEFINES}")
    message(STATUS  "-----------------------------------------")

  endif()

  list(REMOVE_ITEM TP_LIBRARIES ${VAR_TP_TARGET} )

  #== Build Lib ====================================================================================
  if(VAR_TP_TEMPLATE STREQUAL "lib")
    if(WIN32)
      add_library("${VAR_TP_TARGET}" STATIC ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
    else()
      add_library("${VAR_TP_TARGET}" ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
    endif()

    target_include_directories(${VAR_TP_TARGET} PUBLIC ${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    target_compile_definitions(${VAR_TP_TARGET} PRIVATE ${VAR_TP_DEFINES} PUBLIC ${TP_DEFINES})
    target_compile_options(${VAR_TP_TARGET} PRIVATE ${TP_CFLAGS} ${TP_CXXFLAGS} ${TP_LFLAGS})
    target_link_directories(${VAR_TP_TARGET} PUBLIC ${TP_LIBRARYPATHS})

    list(REMOVE_ITEM TP_LIBRARIES ${VAR_TP_TARGET} )

    target_link_libraries("${VAR_TP_TARGET}" PUBLIC ${TP_LIBRARIES} PUBLIC ${TP_DEPENDENCIES} PUBLIC ${TP_QT_MODULES})

  endif()

  #== Build PyLib ==================================================================================
  if(VAR_TP_TEMPLATE STREQUAL "pylib")

    if(WIN32)
      add_library("${VAR_TP_TARGET}" SHARED ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
    elseif(UNIX)
      add_library("${VAR_TP_TARGET}" SHARED ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
      set_target_properties( "${VAR_TP_TARGET}"
        PROPERTIES          
          LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
          RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
          PREFIX ""
      )
    endif()
    target_include_directories(${VAR_TP_TARGET} PUBLIC ${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_definitions("${TP_CFLAGS} ${TP_CXXFLAGS} ${TP_LFLAGS}")

    target_link_libraries("${VAR_TP_TARGET}" PUBLIC ${TP_LIBRARIES} ${TP_DEPENDENCIES} ${TP_QT_MODULES})

  endif()


  #== Build App ====================================================================================
  if(VAR_TP_TEMPLATE STREQUAL "app" OR VAR_TP_TEMPLATE STREQUAL "test")
    
    if(ANDROID)
      # For Android we build a shared library then call it from Java.
      add_library("${VAR_TP_TARGET}" SHARED ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
    else()
      add_executable("${VAR_TP_TARGET}" ${VAR_TP_SOURCES} ${VAR_TP_HEADERS} ${VAR_TP_RESOURCES})
    endif()

    set_target_properties("${VAR_TP_TARGET}" PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/")

    target_include_directories(${VAR_TP_TARGET} PRIVATE ${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    target_link_directories(${VAR_TP_TARGET} PRIVATE ${TP_LIBRARYPATHS})
    target_compile_options(${VAR_TP_TARGET} PRIVATE ${TP_CFLAGS} ${TP_CXXFLAGS} ${TP_LFLAGS})
    target_compile_definitions(${VAR_TP_TARGET} PRIVATE ${VAR_TP_DEFINES} PUBLIC ${TP_DEFINES})

    list(REMOVE_ITEM TP_LIBRARIES ${VAR_TP_TARGET} )
    target_link_libraries(${VAR_TP_TARGET} PUBLIC ${TP_LIBRARIES} ${TP_DEPENDENCIES} ${TP_QT_MODULES})

    if(VAR_TP_TEMPLATE STREQUAL "app")
      if(APPLE)
        install(TARGETS "${VAR_TP_TARGET}"
                RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
                BUNDLE  DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

        if(IOS)
          execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" PRODUCT_BUNDLE_IDENTIFIER
                          WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                          OUTPUT_VARIABLE PRODUCT_BUNDLE_IDENTIFIER)
          string(STRIP "${PRODUCT_BUNDLE_IDENTIFIER}" PRODUCT_BUNDLE_IDENTIFIER)

          execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" DEVELOPMENT_TEAM
                          WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                          OUTPUT_VARIABLE DEVELOPMENT_TEAM)
          string(STRIP "${DEVELOPMENT_TEAM}" DEVELOPMENT_TEAM)

          set_xcode_property("${VAR_TP_TARGET}" PRODUCT_BUNDLE_IDENTIFIER "${PRODUCT_BUNDLE_IDENTIFIER}" "All")
          set_xcode_property(${VAR_TP_TARGET} DEVELOPMENT_TEAM "${DEVELOPMENT_TEAM}" "All")
        endif()

      else( UNIX )
        install(TARGETS "${VAR_TP_TARGET}"
                RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
                LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
      endif()
    endif()
  endif()

  #== Build Subdirs ================================================================================
  if(VAR_TP_TEMPLATE STREQUAL "subdirs")
    add_library(${VAR_TP_TARGET} INTERFACE)
    target_include_directories(${VAR_TP_TARGET} INTERFACE ${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    target_compile_definitions(${VAR_TP_TARGET} INTERFACE ${TP_DEFINES})
  endif()

endfunction() 


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# For documentation of the supported variabls see:
# https://github.com/tdp-libs/tp_build/blob/master/documentation/variables.md
function(tp_parse_vars)  
  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" HEADERS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_HEADERS
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" SOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_SOURCES
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TP_RC
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RC
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" RESOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RESOURCES
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TARGET
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TARGET
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TEMPLATE
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TEMPLATE
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_INCLUDEPATHS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" SYSTEM_INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_SYSTEM_INCLUDEPATHS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" RELATIVE_SYSTEM_INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RELATIVE_SYSTEM_INCLUDEPATHS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARIES_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_FRAMEWORKS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_FRAMEWORKS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" SLIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_SLIBS
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARYPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARYPATHS_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" DEFINES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEFINES_
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_DEPENDENCIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEPENDENCIES
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_STATIC_INIT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_STATIC_INIT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_QT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QTPLUGIN
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_QTPLUGIN
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" CFLAGS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_CFLAGS
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" CXXFLAGS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_CXXFLAGS
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_git/extract_git_branch.sh" 
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_BRANCH
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_git/extract_git_commit.sh" 
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_GIT_COMMIT
                  OUTPUT_STRIP_TRAILING_WHITESPACE)


  #== INCLUDEPATHS =================================================================================
  string(REPLACE " " ";" TP_INCLUDEPATHS "${TP_INCLUDEPATHS} ${TP_INCLUDEPATHS_}")
  string(STRIP "${TP_INCLUDEPATHS}" TP_INCLUDEPATHS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_INCLUDEPATHS})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_INCLUDEPATHS "${TP_TMP_LIST}")


  #== SYSTEM_INCLUDEPATHS ==========================================================================
  string(REPLACE " " ";" TP_SYSTEM_INCLUDEPATHS "${TP_SYSTEM_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS_}")
  string(STRIP "${TP_SYSTEM_INCLUDEPATHS}" TP_SYSTEM_INCLUDEPATHS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_SYSTEM_INCLUDEPATHS})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_SYSTEM_INCLUDEPATHS "${TP_TMP_LIST}")


  #== RELATIVE_SYSTEM_INCLUDEPATHS =================================================================
  string(REPLACE " " ";" TP_RELATIVE_SYSTEM_INCLUDEPATHS "${TP_RELATIVE_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS_}")
  string(STRIP "${TP_RELATIVE_SYSTEM_INCLUDEPATHS}" TP_RELATIVE_SYSTEM_INCLUDEPATHS)
  set(TP_TMP_LIST "")
  foreach(f ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_RELATIVE_SYSTEM_INCLUDEPATHS "${TP_TMP_LIST}")


  #== LIBRARYPATHS =================================================================================
  string(STRIP "${TP_LIBRARYPATHS}" TP_LIBRARYPATHS)
  string(STRIP "${TP_LIBRARYPATHS_}" TP_LIBRARYPATHS_)
  string(REPLACE " " ";" TP_LIBRARYPATHS "${TP_LIBRARYPATHS}")
  string(REPLACE " " ";" TP_LIBRARYPATHS_ "${TP_LIBRARYPATHS_}")
  set(TP_TMP_LIST "")
  foreach(f ${TP_LIBRARYPATHS})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  foreach(f ${TP_LIBRARYPATHS_})
    if(IS_ABSOLUTE "${f}")
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "../${f}")
    endif()
  endforeach(f)
  set(TP_LIBRARYPATHS "${TP_TMP_LIST}")


  #== LIBRARIES ====================================================================================
  set(TP_TMP_LIST "")
  macro(clean_and_add_libraries PARTS_ARG)
    if(NOT "${PARTS_ARG}" STREQUAL "")
      string(STRIP "${PARTS_ARG}" PARTS)
      if(NOT "${PARTS}" STREQUAL "")
        string(REPLACE " " ";" PARTS "${PARTS}")
        string(REGEX REPLACE "\n$" "" PARTS "${PARTS}")
        string(REGEX REPLACE "\r$" "" PARTS "${PARTS}")
        foreach(f ${PARTS})          
          string(STRIP "${f}" f)
          list(APPEND TP_TMP_LIST "${f}")
        endforeach(f)
      endif()
    endif()
  endmacro()

  clean_and_add_libraries("${TP_LIBRARIES}")
  clean_and_add_libraries("${TP_LIBRARIES_}")
  clean_and_add_libraries("${TP_LIBS}")
  clean_and_add_libraries("${TP_LIBS_}")
  clean_and_add_libraries("${TP_SLIBS}")
  set(TP_LIBRARIES "${TP_TMP_LIST}")

  string(STRIP "${TP_DEPENDENCIES}" TP_DEPENDENCIES)
  if(NOT "${TP_DEPENDENCIES}" STREQUAL "")
    string(REPLACE " " ";" TP_DEPENDENCIES "${TP_DEPENDENCIES}")
    list(REMOVE_DUPLICATES TP_DEPENDENCIES)
    foreach(f ${TP_DEPENDENCIES})
      if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
        include("${CMAKE_CURRENT_LIST_DIR}/../${f}/cmake.cmake")
      else()
        include("${CMAKE_CURRENT_LIST_DIR}/../tp_build/dependencies/${f}/cmake.cmake")
      endif()
    endforeach(f)
  endif()

  list(REVERSE TP_LIBRARIES)
  list(REMOVE_DUPLICATES TP_LIBRARIES)
  list(REVERSE TP_LIBRARIES)

  #== FRAMEWORKS ===================================================================================
  if(APPLE)
    macro(clean_and_add_frameworks PARTS_ARG)
      if(NOT "${PARTS_ARG}" STREQUAL "")
        string(STRIP "${PARTS_ARG}" PARTS)
        if(NOT "${PARTS}" STREQUAL "")
          string(REPLACE " " ";" PARTS "${PARTS}")
          string(REGEX REPLACE "\n$" "" PARTS "${PARTS}")
          string(REGEX REPLACE "\r$" "" PARTS "${PARTS}")
          foreach(f ${PARTS})
            list(APPEND TP_LIBRARIES "-framework ${f}")
          endforeach(f)
        endif()
      endif()
    endmacro()

    clean_and_add_frameworks("${TP_FRAMEWORKS}")
    clean_and_add_frameworks("${TP_FRAMEWORKS_}")
  endif()

  #== DEFINES ======================================================================================
  set(TP_TMP_LIST "")
  list(APPEND TP_TMP_LIST "-DTP_GIT_BRANCH=${TP_GIT_BRANCH}")
  list(APPEND TP_TMP_LIST "-DTP_GIT_COMMIT=${TP_GIT_COMMIT}")
  macro(clean_and_add_defines PARTS_ARG)
    if(NOT "${PARTS_ARG}" STREQUAL "")
      string(STRIP "${PARTS_ARG}" PARTS)
      if(NOT "${PARTS}" STREQUAL "")
        string(REPLACE " " ";" PARTS "${PARTS}")
        string(REGEX REPLACE "\n$" "" PARTS "${PARTS}")
        string(REGEX REPLACE "\r$" "" PARTS "${PARTS}")
        foreach(f ${PARTS})          
          string(FIND "${f}" "-" out)
          if("${out}" EQUAL 0)
            list(APPEND TP_TMP_LIST "${f}")
          else()
            list(APPEND TP_TMP_LIST "-D${f}")
          endif()
        endforeach(f)
      endif()
    endif()
  endmacro()

  clean_and_add_defines("${DEFINES}")
  clean_and_add_defines("${TP_DEFINES}")
  clean_and_add_defines("${TP_DEFINES_}")
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
    list(APPEND TP_DEFINES -DTP_WIN32)
  endif()

  #== TP_TEMPLATE ==================================================================================
  string(STRIP "${TP_TEMPLATE}" TP_TEMPLATE)

  #== TP_TARGET ====================================================================================
  string(STRIP "${TP_TARGET}" TP_TARGET)

  #== SOURCES ======================================================================================
  if(NOT "${TP_SOURCES}" STREQUAL "")
    string(REPLACE " " ";" TP_SOURCES ${TP_SOURCES})
    string(STRIP "${TP_SOURCES}" TP_SOURCES)
  endif()

  #== HEADERS ======================================================================================
  if(NOT "${TP_HEADERS}" STREQUAL "")
    string(REPLACE " " ";" TP_HEADERS ${TP_HEADERS})
    string(STRIP "${TP_HEADERS}" TP_HEADERS)
  endif()

  #== Qt RESOURCES =================================================================================
  if(NOT "${TP_RESOURCES}" STREQUAL "")
    string(REPLACE " " ";" TP_RESOURCES ${TP_RESOURCES})
    string(STRIP "${TP_RESOURCES}" TP_RESOURCES)
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

  if(NOT "${TP_RC}" STREQUAL "")
    string(REPLACE " " ";" TP_RC ${TP_RC})
    string(STRIP "${TP_RC}" TP_RC)
    foreach(f ${TP_RC})
      get_filename_component(QRC_NAME "${f}" NAME_WE)
      add_custom_command(
        OUTPUT  "${QRC_NAME}.cpp"
        COMMAND "${TP_RC_CMD}" --compile "${CMAKE_CURRENT_LIST_DIR}/${f}" "${CMAKE_CURRENT_BINARY_DIR}/${QRC_NAME}.cpp" ${QRC_NAME}
        DEPENDS "${CMAKE_CURRENT_LIST_DIR}/${f}" "${TP_RC_CMD}"
      )
      list(APPEND TP_SOURCES "${QRC_NAME}.cpp")
    endforeach(f)
  endif()

  #== STATIC_INIT ==================================================================================
  if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
    if(NOT "${TP_STATIC_INIT}" STREQUAL "")
      string(REPLACE " " ";" TP_STATIC_INIT ${TP_STATIC_INIT})
      string(STRIP "${TP_STATIC_INIT}" TP_STATIC_INIT)
      foreach(f ${TP_STATIC_INIT})
        add_custom_command(
          OUTPUT  "${f}.cpp"
          COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_static_init/generate_static_init.sh" "${f}.cpp" ${f}
          DEPENDS "${CMAKE_CURRENT_LIST_DIR}/../${f}/inc/${f}/Globals.h" "${CMAKE_CURRENT_LIST_DIR}/../${f}/src/Globals.cpp" "${CMAKE_CURRENT_LIST_DIR}/../tp_build/tp_static_init/generate_static_init.sh"
        )
  
        list(APPEND TP_SOURCES "${f}.cpp")
      endforeach(f)
    endif()
  endif()

  #== QT ===========================================================================================
  if(NOT "${TP_QT}" STREQUAL "")
    string(REPLACE " " ";" TP_QT ${TP_QT})
    string(STRIP "${TP_QT}" TP_QT)  
    list(REMOVE_DUPLICATES TP_QT)  
    if(TP_QT)
      message("${TP_TARGET} uses Qt modules: (${TP_QT})")
  
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
          find_package(Qt5Core REQUIRED)
          list(APPEND TP_QT_MODULES "Core")
  
        elseif(f STREQUAL "gui")
          find_package(Qt5Gui REQUIRED)
          list(APPEND TP_QT_MODULES "Gui")
  
        elseif(f STREQUAL "widgets")
          find_package(Qt5Widgets REQUIRED)
          list(APPEND TP_QT_MODULES "Widgets")
  
          if(UNIX AND QT_STATIC)
            #Remember that you need this somewhere in your application.
            # Q_IMPORT_PLUGIN(QXcbIntegrationPlugin)
            # Q_IMPORT_PLUGIN(QXcbGlxIntegrationPlugin)

            get_target_property(tmp_loc Qt5::QXcbGlxIntegrationPlugin LOCATION)
            list(APPEND TP_LIBRARIES "${tmp_loc}")
            list(APPEND TP_LIBRARIES "${Qt5Gui_PLUGINS}")
          endif()
  
          if(WIN32 AND QT_STATIC)
            #Remember that you need this somewhere in your application.
            # Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)

            get_target_property(tmp_loc Qt5::QWindowsIntegrationPlugin LOCATION)
            list(APPEND TP_LIBRARIES "${tmp_loc}")
            list(APPEND TP_LIBRARIES "${Qt5Gui_PLUGINS}")
          endif()
  
        elseif(f STREQUAL "opengl")
          find_package(Qt5OpenGL REQUIRED)
          list(APPEND TP_QT_MODULES "OpenGL")
        endif()
      endforeach(f)
  
      find_package(Qt5 COMPONENTS Core)
  
      if(NOT "${TP_QTPLUGIN}" STREQUAL "")
        string(REPLACE " " ";" TP_QTPLUGIN ${TP_QTPLUGIN})
        string(STRIP "${TP_QTPLUGIN}" TP_QTPLUGIN)
        list(REMOVE_DUPLICATES TP_QTPLUGIN)
        if(TP_QTPLUGIN AND QT_STATIC)
          message("${TP_TARGET} uses Qt plugins: (${TP_QTPLUGIN})")
          foreach(f ${TP_QTPLUGIN})
            if(f STREQUAL "qpng" AND TARGET Qt5::QPngPlugin)
              get_target_property(tmp_loc Qt5::QPngPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qjpeg" AND TARGET Qt5::QJpegPlugin)
              get_target_property(tmp_loc Qt5::QJpegPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qbmp" AND TARGET Qt5::QBmpPlugin)
              get_target_property(tmp_loc Qt5::QBmpPlugin LOCATION_Debug)
              list(APPEND TP_LIBRARIES "${tmp_loc}")
            elseif(f STREQUAL "qgif" AND TARGET Qt5::QGifPlugin)
              get_target_property(tmp_loc Qt5::QGifPlugin LOCATION_Debug)
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

  #== Build Lib ====================================================================================
  if(TP_TEMPLATE STREQUAL "lib")
    include_directories(${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_definitions("${TP_CFLAGS} ${TP_CXXFLAGS} ${TP_LFLAGS}")

    if(WIN32)
      add_library("${TP_TARGET}" STATIC ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    else()
      add_library("${TP_TARGET}" ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    endif()
  endif()

  #== Build PyLib ====================================================================================
  if(TP_TEMPLATE STREQUAL "pylib")
    include_directories(${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_definitions("${TP_CFLAGS} ${TP_CXXFLAGS} ${TP_LFLAGS}")

    if(WIN32)
      add_library("${TP_TARGET}" SHARED ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    elseif(UNIX)
      add_library("${TP_TARGET}" SHARED ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
      set_target_properties( "${TP_TARGET}"
        PROPERTIES          
          LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
          RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
          PREFIX ""
      )
    endif()
    
    target_link_libraries("${TP_TARGET}" ${TP_LIBRARIES})    

  endif()


  #== Build App ====================================================================================
  if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
    include_directories(${TP_INCLUDEPATHS} ${TP_SYSTEM_INCLUDEPATHS} ${TP_RELATIVE_SYSTEM_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    
    if(ANDROID)
      # For Android we build a shared library then call it from Java.
      add_library("${TP_TARGET}" SHARED ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    else()
      add_executable("${TP_TARGET}" ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    endif()

    target_link_libraries("${TP_TARGET}" ${TP_LIBRARIES})
    if(TP_TEMPLATE STREQUAL "app")
      if(APPLE)
        install(TARGETS "${TP_TARGET}" 
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

          set_xcode_property("${TP_TARGET}" PRODUCT_BUNDLE_IDENTIFIER "${PRODUCT_BUNDLE_IDENTIFIER}" "All")
          set_xcode_property(${TP_TARGET} DEVELOPMENT_TEAM "${DEVELOPMENT_TEAM}" "All")
        endif()

      else( UNIX )
        install(TARGETS "${TP_TARGET}" 
                RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
                LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
      endif()
    endif()
  endif()

  #== Build Subdirs ================================================================================
  if(NOT TP_TEMPLATE STREQUAL "subdirs")
    if(TP_QT_MODULES)
      qt5_use_modules("${TP_TARGET}" ${TP_QT_MODULES})
    endif()
  endif()

endfunction() 


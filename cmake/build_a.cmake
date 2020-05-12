set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-pthread")

# For documentation of the supported variabls see:
# https://github.com/tdp-libs/tp_build/blob/master/documentation/variables.md
function(tp_parse_vars)  
  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" HEADERS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_HEADERS)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" SOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_SOURCES)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TARGET
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TARGET)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TEMPLATE
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_TEMPLATE)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" TP_RC
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RC)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" RESOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RESOURCES)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_INCLUDEPATHS_)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARIES_)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBS_)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARYPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARYPATHS_)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" DEFINES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEFINES_)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_DEPENDENCIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEPENDENCIES)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_STATIC_INIT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_STATIC_INIT)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_QT)

  execute_process(COMMAND bash "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QTPLUGIN
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_QTPLUGIN)

  string(REPLACE " " ";" TP_INCLUDEPATHS "${TP_INCLUDEPATHS} ${TP_INCLUDEPATHS_}")
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

  string(REPLACE " " ";" TP_LIBRARYPATHS "${TP_LIBRARYPATHS} ${TP_LIBRARYPATHS_}")
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

  string(REPLACE " " ";" TP_LIBRARIES "${TP_LIBRARIES} ${TP_LIBRARIES_}")
  string(STRIP "${TP_LIBRARIES}" TP_LIBRARIES)
  string(REPLACE " " ";" TP_LIBS "${TP_LIBS} ${TP_LIBS_}")
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

  string(REPLACE " " ";" TP_DEFINES "${DEFINES} ${TP_DEFINES} ${TP_DEFINES_}")
  string(STRIP "${TP_DEFINES}" TP_DEFINES)
  set(TP_TMP_LIST "")
  foreach(f ${TP_DEFINES})
    string(FIND "${f}" "-" out)
    if("${out}" EQUAL 0)
      list(APPEND TP_TMP_LIST "${f}")
    else()
      list(APPEND TP_TMP_LIST "-D${f}")
    endif()
  endforeach(f)
  set(TP_DEFINES "${TP_TMP_LIST}")

  string(STRIP "${TP_TEMPLATE}" TP_TEMPLATE)

  string(STRIP "${TP_TARGET}" TP_TARGET)

  string(REPLACE " " ";" TP_SOURCES ${TP_SOURCES})
  string(STRIP "${TP_SOURCES}" TP_SOURCES)

  string(REPLACE " " ";" TP_HEADERS ${TP_HEADERS})
  string(STRIP "${TP_HEADERS}" TP_HEADERS)

  string(REPLACE " " ";" TP_RESOURCES ${TP_RESOURCES})
  string(STRIP "${TP_RESOURCES}" TP_RESOURCES)

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

  if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
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
          get_target_property(tmp_loc Qt5::QXcbGlxIntegrationPlugin LOCATION)
          list(APPEND TP_LIBRARIES "${tmp_loc}")
          list(APPEND TP_LIBRARIES "${Qt5Gui_PLUGINS}")
        endif()

      elseif(f STREQUAL "opengl")
        find_package(Qt5OpenGL REQUIRED)
        list(APPEND TP_QT_MODULES "OpenGL")
      endif()
    endforeach(f)

    find_package(Qt5 COMPONENTS Core)

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

  if(APPLE)
    list(APPEND TP_DEFINES -DTP_OSX)
  elseif( ANDROID )
    list(APPEND TP_DEFINES -DTP_ANDROID)
  elseif( UNIX )
    list(APPEND TP_DEFINES -DTP_LINUX)
  endif()

  if(TP_TEMPLATE STREQUAL "lib")
    include_directories(${TP_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_library("${TP_TARGET}" ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
  endif()

  if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
    include_directories(${TP_INCLUDEPATHS})
    link_directories(${TP_LIBRARYPATHS})
    add_definitions(${TP_DEFINES})
    add_executable("${TP_TARGET}" ${TP_SOURCES} ${TP_HEADERS} ${TP_RESOURCES})
    target_link_libraries("${TP_TARGET}" ${TP_LIBRARIES})
    if(TP_TEMPLATE STREQUAL "app")
      install(TARGETS "${TP_TARGET}" RUNTIME DESTINATION bin)
    endif()
  endif()

  if(NOT TP_TEMPLATE STREQUAL "subdirs")
    if(TP_QT_MODULES)
      qt5_use_modules("${TP_TARGET}" ${TP_QT_MODULES})
    endif()
  endif()

endfunction() 


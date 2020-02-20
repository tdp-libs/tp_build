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

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" RESOURCES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_RESOURCES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" INCLUDEPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_INCLUDEPATHS_)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARIES_)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBS_)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" LIBRARYPATHS
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_LIBRARYPATHS_)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" DEFINES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEFINES_)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_DEPENDENCIES
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_DEPENDENCIES)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_QT)

  execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" TP_STATIC_INIT
                  WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
                  OUTPUT_VARIABLE TP_STATIC_INIT)

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
    list(APPEND TP_TMP_LIST "-D${f}")
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

  ### execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_dependencies.sh" QT
  ###                 WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  ###                 OUTPUT_VARIABLE TP_QT)



######## ##Use:
######## ##In dependencies.pri
######## ##TP_STATIC_INIT += module_name
######## 
######## if(TP_TEMPLATE STREQUAL "app" OR TP_TEMPLATE STREQUAL "test")
######## 
######## 
########   #execute_process(COMMAND "${CMAKE_CURRENT_LIST_DIR}/../tp_build/cmake/extract_vars.sh" RESOURCES
########   #                WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
########   #                OUTPUT_VARIABLE TP_RESOURCES)
######## 
######## 
######## 
########   TP_STATIC_INIT = $$unique(TP_STATIC_INIT)
########   for(SRC, TP_STATIC_INIT) {
########     TP_STATIC_INIT_SOURCES += ../$${SRC}/$${SRC}.pro
########   }
######## 
########   tpStaticInit.name = Generate init code
########   tpStaticInit.input = TP_STATIC_INIT_SOURCES
########   tpStaticInit.depends += $$PWD/../tp_static_init/generate_static_init.sh
########   tpStaticInit.depends += $$PWD/../../${QMAKE_FILE_IN_BASE}/inc/${QMAKE_FILE_IN_BASE}/Globals.h
########   tpStaticInit.depends += $$PWD/../../${QMAKE_FILE_IN_BASE}/src/Globals.cpp
########   tpStaticInit.commands = bash $$PWD/../tp_static_init/generate_static_init.sh ${QMAKE_FILE_OUT} ${QMAKE_FILE_IN_BASE}
########   tpStaticInit.output = ${QMAKE_VAR_OBJECTS_DIR}/${QMAKE_FILE_IN_BASE}_static_init.cpp
########   tpStaticInit.clean = ${QMAKE_VAR_OBJECTS_DIR}/${QMAKE_FILE_IN_BASE}_static_init.cpp
########   tpStaticInit.variable_out = SOURCES
########   QMAKE_EXTRA_COMPILERS += tpStaticInit
######## endif()



  string(REPLACE " " ";" TP_QT ${TP_QT})
  string(STRIP "${TP_QT}" TP_QT)
  list(REMOVE_DUPLICATES TP_QT)
  if(TP_QT)
    message("${TP_TARGET} uses Qt modules: (${TP_QT})")

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
      elseif(f STREQUAL "opengl")
        find_package(Qt5OpenGL REQUIRED)
        list(APPEND TP_QT_MODULES "OpenGL")
      endif()
    endforeach(f)

    find_package(Qt5 COMPONENTS Core)

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

  if(TP_TEMPLATE STREQUAL "subdirs")
    
  endif()

  if(TP_QT_MODULES)
    qt5_use_modules("${TP_TARGET}" ${TP_QT_MODULES})
  endif()

endfunction() 


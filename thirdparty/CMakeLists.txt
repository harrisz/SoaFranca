function(initialize_submodule DIRECTORY)
    if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${DIRECTORY}/.git)
        find_package(Git QUIET REQUIRED)
        message(STATUS "${CMAKE_CURRENT_SOURCE_DIR}/${DIRECTORY}/.git does not exist. Initializing ${DIRECTORY} submodule ...")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init ${DIRECTORY}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                RESULT_VARIABLE GIT_EXIT_CODE)
        if(NOT GIT_EXIT_CODE EQUAL "0")
            message(FATAL_ERROR "${GIT_EXECUTABLE} submodule update --init dependencies/${DIRECTORY} failed with exit code ${GIT_EXIT_CODE}, please checkout submodules")
        endif()
    endif()
endfunction(initialize_submodule)
initialize_submodule(capicxx-core-runtime)
initialize_submodule(capicxx-dbus-runtime)

set(PKG_CONFIG_PATH ./dbus-1.10.10)
message("PKG_CONFIG_PATH variable is $ENV{PKG_CONFIG_PATH}")
set(ENV{PKG_CONFIG_PATH} "${PWD}/dbus-1.10.10")

SET(USE_INSTALLED_COMMONAPI OFF CACHE BOOL "Use installed commonapi OFF")
SET(USE_INSTALLED_DBUS OFF CACHE BOOL "Use installed commonapi OFF")

add_subdirectory(capicxx-core-runtime)
add_subdirectory(capicxx-dbus-runtime)
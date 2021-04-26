cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread -std=c++0x")

# Include symbols, just in case we need to debug a crash
set(CMAKE_BUILD_TYPE Debug)
message(STATUS "project dir: ${PRJ_SRC_DIR}")
message(STATUS "harris project source dir: ${PROJECT_SOURCE_DIR}")
set(FIDL_DIR ${PROJECT_SOURCE_DIR}/examples/fidl/)
set(SRC_GEN_DIR ${PROJECT_SOURCE_DIR}/examples/src-gen)

include_directories(
        src-gen
        ${PROJECT_SOURCE_DIR}/thirdparty/capicxx-core-runtime/include
        ${PROJECT_SOURCE_DIR}/thirdparty/capicxx-dbus-runtime/include
        ${PROJECT_SOURCE_DIR}/thirdparty/capicxx-someip-runtime/include
        ${PROJECT_SOURCE_DIR}/thirdparty/dbus-1.10.10/
)

link_directories(${CMAKE_BINARY_DIR}/thirdparty/capicxx-core-runtime/
        ${CMAKE_BINARY_DIR}/thirdparty/capicxx-dbus-runtime/
        ${CMAKE_BINARY_DIR}/thirdparty/capicxx-someip-runtime/
        ${CMAKE_BINARY_DIR}/thirdparty/vsomeip/
        ${PROJECT_SOURCE_DIR}/thirdparty/dbus-1.10.10/dbus/.libs/
        )

message("Generator: ${FIDL_CORE_GENERATOR}")
set(GEN_FIDL_CORE_CMD ${FIDL_CORE_GENERATOR} -dest ${SRC_GEN_DIR} -sk ${PROJECT_SOURCE_DIR}/examples/fidl/HelloWorld.fidl)
set(GEN_FIDL_DBUS_CMD ${FIDL_DBUS_GENERATOR} -dest ${SRC_GEN_DIR} ${PROJECT_SOURCE_DIR}/examples/fidl/HelloWorld.fidl)
set(GEN_FIDL_SOMEIP_CMD ${FIDL_SOMEIP_GENERATOR} -dest ${SRC_GEN_DIR} ${PROJECT_SOURCE_DIR}/examples/fidl/HelloWorld.fdepl)

execute_process(
        COMMAND ${GEN_FIDL_CORE_CMD}
        COMMAND ${GEN_FIDL_DBUS_CMD}
        COMMAND ${GEN_FIDL_SOMEIP_CMD}
)

#add_custom_command(
#        OUTPUT fidl_generated_successfully
#        #COMMAND touch fidl_generated_successfully
#        COMMAND ${GEN_FIDL_CORE_CMD}
#        COMMAND ${GEN_FIDL_DBUS_CMD}
#)

#add_custom_command(OUTPUT ${SRC_GEN_DIR}/fidl_generated_successfully
#    COMMAND ${GEN_FIDL_CORE_CMD}
#    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/examples
#    COMMENT "Call CommonAPI code generator."
#    )
add_custom_target(fidl_gen DEPENDS fidl_generated_successfully)


#include_directories(
#    src-gen
#    ../install/include
#    ../install/include/CommonAPI-3.1
#    ../install/include/CommonAPI-3.1/DBus
#    ../install/include/CommonAPI-3.1/SomeIP
#    ../install/include/dbus-1.0
#    # A few header files seem to not be installed now - need to get them from the source directory.
#    ../dbus-1.10.10
#)

# CMake needs the policy set to avoid warning about
# how to handle a relative path for linking.
# Then we set link search path relative to the source
# dir (thus reaching the locally built libraries we created)
# - Gunnar
#cmake_policy(SET CMP0015 NEW)
#link_directories(
#    ../install/lib
#)
#
add_executable(HelloWorldClient
    src/HelloWorldClient.cpp
    src-gen/v1/commonapi/HelloWorldDBusProxy.cpp
    src-gen/v1/commonapi/HelloWorldDBusDeployment.cpp
)
#add_dependencies(HelloWorldClient  fidl_gen)
target_link_libraries(HelloWorldClient CommonAPI CommonAPI-DBus dbus-1)

add_executable(HelloWorldService
    src/HelloWorldService.cpp
    src/HelloWorldStubImpl.cpp
    src-gen/v1/commonapi/HelloWorldDBusStubAdapter.cpp
    src-gen/v1/commonapi/HelloWorldStubDefault.hpp
    src-gen/v1/commonapi/HelloWorldDBusDeployment.cpp
)
target_link_libraries(HelloWorldService CommonAPI CommonAPI-DBus dbus-1)

##SOMEIP examples
add_executable(HelloWorldSomeIPClient
	src/HelloWorldClient.cpp
	src-gen/v1/commonapi/HelloWorldSomeIPProxy.cpp
	src-gen/v1/commonapi/HelloWorldSomeIPDeployment.cpp
)
target_link_libraries(HelloWorldSomeIPClient CommonAPI CommonAPI-SomeIP vsomeip3)
add_executable(HelloWorldSomeIPService
	src/HelloWorldService.cpp
	src/HelloWorldStubImpl.cpp
	src-gen/v1/commonapi/HelloWorldSomeIPStubAdapter.cpp
	src-gen/v1/commonapi/HelloWorldStubDefault.hpp
	src-gen/v1/commonapi/HelloWorldSomeIPDeployment.cpp
)
target_link_libraries(HelloWorldSomeIPService CommonAPI CommonAPI-SomeIP vsomeip3)
#
#install(PROGRAMS build/HelloWorldService build/HelloWorldSomeIPService DESTINATION ../install/bin/)

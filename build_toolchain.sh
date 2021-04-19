#!/bin/bash

git submodule init
git submodule update

currentPath=${PWD}
echo "${currentPath}"

if [ ! -f  "dbus-1.10.10.tar.gz" ]
then
  wget http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz
	if [ -d "thirdparty/dbus-1.10.10" ]
	then
		rm -rf thirdparty/dbus-1.10.10
	fi
	tar -xzf dbus-1.10.10.tar.gz  -C thirdparty/ 
	cd thirdparty/dbus-1.10.10
	for i in ../capicxx-dbus-runtime/src/dbus-patches/*.patch; do patch -p1 < $i; done
	./configure
	make
    cd ../../
fi


if [ ! -d "toolchains" ]
then
	mkdir toolchains
fi

if [ ! -d "host_tools" ]
then
	mkdir host_tools
fi

cd ${currentPath}/toolchains
if [ ! -e "commonapi_core_generator.zip" ]
then
    wget https://github.com/GENIVI/capicxx-core-tools/releases/latest/download/commonapi_core_generator.zip
    cd ${currentPath}
fi
unzip -o toolchains/commonapi_core_generator.zip -d host_tools/commonapi_core_generator

cd ${currentPath}/toolchains
if [ ! -e "commonapi_dbus_generator.zip" ]
then
    wget https://github.com/GENIVI/capicxx-dbus-tools/releases/latest/download/commonapi_dbus_generator.zip
    cd ${currentPath}
fi
unzip -o toolchains/commonapi_dbus_generator.zip -d host_tools/commonapi_dbus_generator

cd ${currentPath}/toolchains
if [ ! -e "commonapi_someip_generator.zip" ]
then
    wget https://github.com/GENIVI/capicxx-someip-tools/releases/latest/download/commonapi_someip_generator.zip
    cd ${currentPath}
fi
unzip -o toolchains/commonapi_someip_generator.zip -d host_tools/commonapi_someip_generator

### build
cd ${currentPath}
mkdir build
cd build
cmake ..
make

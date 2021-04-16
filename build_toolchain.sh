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

cd toolchains
git clone --depth=1 https://github.com/GENIVI/capicxx-core-tools.git
git clone --depth=1 https://github.com/GENIVI/capicxx-dbus-tools.git
git clone --depth=1 https://github.com/GENIVI/capicxx-someip-tools.git

cd ${currentPath}
if [ ! -e "toolchains/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/commonapi_core_generator.zip" ]
then
    cd toolchains/capicxx-core-tools/org.genivi.commonapi.core.releng
    mvn -Dtarget.id=org.genivi.commonapi.core.target clean verify
    cd ${currentPath}
fi
unzip -o toolchains/capicxx-core-tools/org.genivi.commonapi.core.cli.product/target/products/commonapi_core_generator.zip -d host_tools/commonapi_core_generator

if [ ! -e "toolchains/capicxx-dbus-tools/org.genivi.commonapi.dbus.cli.product/target/products/commonapi_dbus_generator.zip" ]
then
    cd toolchains/capicxx-dbus-tools/org.genivi.commonapi.dbus.releng
    mvn -DCOREPATH=${currentPath}/toolchains/capicxx-core-tools -Dtarget.id=org.genivi.commonapi.dbus.target clean verify
    cd ${currentPath}
fi
unzip -o toolchains/capicxx-dbus-tools/org.genivi.commonapi.dbus.cli.product/target/products/commonapi_dbus_generator.zip -d host_tools/commonapi_dbus_generator

if [ ! -e "toolchains/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/commonapi_someip_generator.zip" ]
then
    cd toolchains/capicxx-someip-tools/org.genivi.commonapi.someip.releng
    mvn -DCOREPATH=${currentPath}/toolchains/capicxx-core-tools -Dtarget.id=org.genivi.commonapi.someip.target clean verify
    cd ${currentPath}
fi
unzip -o toolchains/capicxx-someip-tools/org.genivi.commonapi.someip.cli.product/target/products/commonapi_someip_generator.zip -d host_tools/commonapi_someip_generator

###
#cd ..

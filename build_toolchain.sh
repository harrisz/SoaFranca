#!/bin/bash

git submodule init
git submodule update

if [ ! -f  "dbus-1.10.10.tar.gz" ]
then
  wget http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz
	if [ -d "thirdparty/dbus-1.10.10" ]
	then
		rm -rf thirdparty/dbus-1.10.10
	fi
	tar -xzf dbus-1.10.10.tar.gz  -C thirdparty/ 
	cd thirdparty/dbus-1.10.10
	#for i in ../capicxx-dbus-runtime/src/dbus-patches/*.patch; do patch -p1 < $i; done
	#./configure
	#make
else
	if [ -d "thirdparty/dbus-1.10.10" ]
	then
		rm -rf thirdparty/dbus-1.10.10
	fi
	tar -xzf  dbus-1.10.10.tar.gz  -C thirdparty/
	cd thirdparty/dbus-1.10.10
fi


if [ ! -d "toolchain" ]
then
	mkdir toolchain
fi

cd toolchain
#git clone --depth=1 https://github.com/GENIVI/capicxx-core-tools.git
#git clone --depth=1 https://github.com/GENIVI/capicxx-someip-tools.git
#git clone --depth=1 https://github.com/GENIVI/capicxx-dbus-tools.git

#cd capicxx-core-tools/org.genivi.commonapi.core.releng
#mvn -Dtarget.id=org.genivi.commonapi.core.target clean verify

###
#cd ..

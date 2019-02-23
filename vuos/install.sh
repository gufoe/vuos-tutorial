#!/bin/bash
BASE="$(dirname "$0")"
cd $BASE
BASE=$(pwd)
echo "BASE: $BASE"

# User friendly messages on error
set -E
set -o functrace
function handle_error {
    local retval=$?
    local line=${last_lineno:-$1}
    echo "Failed at $line: $BASH_COMMAND"
    echo "Trace: " "$@"
    exit $retval
}
if (( ${BASH_VERSION%%.*} <= 3 )) || [[ ${BASH_VERSION%.*} = 4.0 ]]; then
        trap '[[ $FUNCNAME = handle_error ]] || { last_lineno=$real_lineno; real_lineno=$LINENO; }' DEBUG
fi
trap 'handle_error $LINENO ${BASH_LINENO[@]}' ERR

# Start installation
rm -rf gits
mkdir gits


cd "$BASE"/gits
	git clone https://github.com/rd235/s2argv-execs.git
	cd s2argv-execs
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
	git clone https://github.com/virtualsquare/vde-2.git
	cd vde-2
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/vdeplug4.git
	cd vdeplug4
	libtoolize
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/virtualsquare/purelibc.git
	mkdir -p purelibc/build
	cd purelibc/build
	cmake ..
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/libvolatilestream.git
	mkdir -p libvolatilestream/build
	cd libvolatilestream/build
	cmake ..
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/libstropt.git
	mkdir -p libstropt/build
	cd libstropt/build
	cmake ..
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/strcase.git
	mkdir -p strcase/build
	cd strcase/build
	cmake ..
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/libvdestack.git
	cd libvdestack
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/vdeplug_vlan.git
	cd vdeplug_vlan
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/cado.git
	cd cado
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/alperakcan/fuse-ext2.git
	cd fuse-ext2
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig


cd "$BASE"/gits
git clone https://github.com/rd235/vdeplug_agno.git
	cd vdeplug_agno
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/rd235/vdens.git
	cd vdens
	autoreconf -if || (libtoolize; autoreconf -if) # WTF is this not compiling at first?
	./configure
	make
	make install
	ldconfig

cd "$BASE"/gits
git clone https://github.com/virtualsquare/vuos.git
	mkdir -p vuos/build
	cd vuos/build
	cmake ..
	make install
	ldconfig
	rm -f /usr/local/lib/vu/modules/vufuseext2.so
	ln -s  /usr/local/lib/umview/modules/umfuseext2.so /usr/local/lib/vu/modules/vufuseext2.so

echo 'Installation completed'

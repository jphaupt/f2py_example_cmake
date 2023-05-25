#/bin/bash

trash build_fortran build_python interface_f2py.pyf

# cd ../fortran-library
# make
mkdir build_fortran
cd build_fortran
cmake -G "Unix Makefiles" ../pointless-fortran/
cmake --build .
cmake --build . --target install
cd ../

mkdir build_python
cd build_python
# workaround: copy over the libfortranlib.so file and the .mod files
# FIXME: don't rely on this, at least not for the .mod files
cp ../build_fortran/lib/libfortranlib.so .
cp ../build_fortran/*.mod .

# generate .pyf file
# cd ..
f2py3 -m interface_f2py -h interface_f2py.pyf ../pointless-fortran/*.f90

LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH

cd ../
LD_LIBRARY_PATH=$PWD/build_fortran/lib:$LD_LIBRARY_PATH
cd build_fortran/CMakeFiles/fortranlib.dir
object_files=$(ls *.o)
cd ../../../
# pwd
cd build_python
# f2py3 --f90flags="-fPIC" -c interface_f2py.pyf ../build_fortran/CMakeFiles/fortranlib.dir/$object_files -Lbuild_fortran -lfortranlib --output=interface_f2py.so -m interface_f2py
f2py3 --f90flags="-fPIC" -c interface_f2py.pyf ../build_fortran/CMakeFiles/fortranlib.dir/*.o -L../build_fortran/lib -lfortranlib --output=interface_f2py.so -m interface_f2py

# workaround: rename the generated shared object file
# FIXME: don't rely on this, or at least use a symlink
mv interface_f2py.*.so interface_f2py.so

export PYTHONPATH=$PWD:$PYTHONPATH
cd ..
# Python code should work now
python3 interface.py

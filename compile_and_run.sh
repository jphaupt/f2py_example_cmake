#/bin/bash

trash *.mod *.o *.so *.pyf

cd ../fortran-library
make

cd ../python-project

# generate .pyf file
f2py3 -m interface_f2py -h interface_f2py.pyf ../fortran-library/*.f90

# workaround: copy over the libfortranlib.so file and the .mod files
# FIXME: don't rely on this, at least not for the .mod files
cp ../fortran-library/libfortranlib.so .
cp ../fortran-library/*.mod .

LD_LIBRARY_PATH=$PWD;$LD_LIBRARY_PATH
f2py3 --f90flags="-fPIC" -c interface_f2py.pyf ../fortran-library/*.o -L../fortran-library -lfortranlib --output=interface_f2py.so -m interface_f2py

# workaround: rename the generated shared object file
# FIXME: don't rely on this, or at least use a symlink
mv interface_f2py.*.so interface_f2py.so

# Python code should work now
python3 interface.py

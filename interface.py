import numpy as np
import interface_f2py
# to check functions do help(interface_f2py) inside the Python REPL (godsend)

a = 10
b = 20
d = interface_f2py.mymodule.add_numbers(a, b)
c = interface_f2py.dependencies.calculate_sum(a, b)

print("Sum of {} and {} is {}".format(a, b, c))
print("Addition of {} and {} is {}".format(a, b, d))

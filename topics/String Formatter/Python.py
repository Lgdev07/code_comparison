# Formatting string using % operator
x = 'Limb'
print("Go %s On a %s"%('Out',x))
# Output: Go Out On a Limb

print('Hit %s The Belt.' %'Below')
# Output: Hit Below The Belt.

print('There are %d dogs.' %4)
# Output: There are 4 dogs.

print('The value of pi is: %5.4f' %(3.141592))
# Output: The value of pi is: 3.1416

print('Floating point numbers: %1.0f' %(13.144))
# Output: Floating point numbers: 13

variable = 12
string = "Variable as integer = %d \n\
Variable as float = %f" %(variable, variable)
print (string)
# Output: Variable as integer = 12
# Output: Variable as float = 12.000000

# Formatting string using format() method
print('We all are {}.'.format('equal'))
# Output: We all are equal.

print('{2} {1} {0}'.format('directions',
                           'the', 'Read'))
# Output: Read the directions.

print('a: {a}, b: {b}, c: {c}'.format(a = 1,
                                      b = 'Two',
                                      c = 12.3))
# Output: a: 1, b: Two, c: 12.3

print('The valueof pi is: %1.5f' %3.141592)
print('The valueof pi is: {0:1.5f}'.format(3.141592))
# Output: The valueof pi is: 3.14159
# Output: The valueof pi is: 3.14159

# Formatted String using F-strings
name = 'Ele'
print(f"My name is {name}.")
# Output: My name is Ele.

a = 5
b = 10
print(f"He said his age is {2 * (a + b)}.")
# Output: He said his age is 30.

print(f"He said his age is {(lambda x: x*2)(3)}")
# Output: He said his age is 6

num = 3.14159
print(f"The valueof pi is: {num:{1}.{5}}")
# Output: The valueof pi is: 3.1416

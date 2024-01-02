from solution import xyz_there
def run_tests():
  correct = 0
  total = 14
  if xyz_there('abcxyz') == True:
    correct += 1
  if xyz_there('abc.xyz') == False:
    correct += 1
  if xyz_there('xyz.abc') == True:
    correct += 1
  if xyz_there('abcxy') == False:
    correct += 1
  if xyz_there('xyz') == True:
    correct += 1
  if xyz_there('xy') == False:
    correct += 1
  if xyz_there('x') == False:
    correct += 1
  if xyz_there('') == False:
    correct += 1
  if xyz_there('abc.xyzxyz') == True:
    correct += 1
  if xyz_there('abc.xxyz') == True:
    correct += 1
  if xyz_there('.xyz') == False:
    correct += 1
  if xyz_there('12.xyz') == False:
    correct += 1
  if xyz_there('12xyz') == True:
    correct += 1
  if xyz_there('1.xyz.xyz2.xyz') == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

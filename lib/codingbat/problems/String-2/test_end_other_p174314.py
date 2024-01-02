from solution import end_other
def run_tests():
  correct = 0
  total = 14
  if end_other('Hiabc', 'abc') == True:
    correct += 1
  if end_other('AbC', 'HiaBc') == True:
    correct += 1
  if end_other('abc', 'abXabc') == True:
    correct += 1
  if end_other('Hiabc', 'abcd') == False:
    correct += 1
  if end_other('Hiabc', 'bc') == True:
    correct += 1
  if end_other('Hiabcx', 'bc') == False:
    correct += 1
  if end_other('abc', 'abc') == True:
    correct += 1
  if end_other('xyz', '12xyz') == True:
    correct += 1
  if end_other('yz', '12xz') == False:
    correct += 1
  if end_other('Z', '12xz') == True:
    correct += 1
  if end_other('12', '12') == True:
    correct += 1
  if end_other('abcXYZ', 'abcDEF') == False:
    correct += 1
  if end_other('ab', 'ab12') == False:
    correct += 1
  if end_other('ab', '12ab') == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import front3
def run_tests():
  correct = 0
  total = 7
  if front3('Java') == 'JavJavJav':
    correct += 1
  if front3('Chocolate') == 'ChoChoCho':
    correct += 1
  if front3('abc') == 'abcabcabc':
    correct += 1
  if front3('abcXYZ') == 'abcabcabc':
    correct += 1
  if front3('ab') == 'ababab':
    correct += 1
  if front3('a') == 'aaa':
    correct += 1
  if front3('') == '':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import front_back
def run_tests():
  correct = 0
  total = 8
  if front_back('code') == 'eodc':
    correct += 1
  if front_back('a') == 'a':
    correct += 1
  if front_back('ab') == 'ba':
    correct += 1
  if front_back('abc') == 'cba':
    correct += 1
  if front_back('') == '':
    correct += 1
  if front_back('Chocolate') == 'ehocolatC':
    correct += 1
  if front_back('aavJ') == 'Java':
    correct += 1
  if front_back('hello') == 'oellh':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import non_start
def run_tests():
  correct = 0
  total = 9
  if non_start('Hello', 'There') == 'ellohere':
    correct += 1
  if non_start('java', 'code') == 'avaode':
    correct += 1
  if non_start('shotl', 'java') == 'hotlava':
    correct += 1
  if non_start('ab', 'xy') == 'by':
    correct += 1
  if non_start('ab', 'x') == 'b':
    correct += 1
  if non_start('x', 'ac') == 'c':
    correct += 1
  if non_start('a', 'x') == '':
    correct += 1
  if non_start('kit', 'kat') == 'itat':
    correct += 1
  if non_start('mart', 'dart') == 'artart':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

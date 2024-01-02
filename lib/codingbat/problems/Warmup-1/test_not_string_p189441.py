from solution import not_string
def run_tests():
  correct = 0
  total = 7
  if not_string('candy') == 'not candy':
    correct += 1
  if not_string('x') == 'not x':
    correct += 1
  if not_string('not bad') == 'not bad':
    correct += 1
  if not_string('bad') == 'not bad':
    correct += 1
  if not_string('not') == 'not':
    correct += 1
  if not_string('is not') == 'not is not':
    correct += 1
  if not_string('no') == 'not no':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

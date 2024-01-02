from solution import first_two
def run_tests():
  correct = 0
  total = 8
  if first_two('Hello') == 'He':
    correct += 1
  if first_two('abcdefg') == 'ab':
    correct += 1
  if first_two('ab') == 'ab':
    correct += 1
  if first_two('a') == 'a':
    correct += 1
  if first_two('') == '':
    correct += 1
  if first_two('Kitten') == 'Ki':
    correct += 1
  if first_two('hi') == 'hi':
    correct += 1
  if first_two('hiya') == 'hi':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

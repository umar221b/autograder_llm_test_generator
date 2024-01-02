from solution import front_times
def run_tests():
  correct = 0
  total = 7
  if front_times('Chocolate', 2) == 'ChoCho':
    correct += 1
  if front_times('Chocolate', 3) == 'ChoChoCho':
    correct += 1
  if front_times('Abc', 3) == 'AbcAbcAbc':
    correct += 1
  if front_times('Ab', 4) == 'AbAbAbAb':
    correct += 1
  if front_times('A', 4) == 'AAAA':
    correct += 1
  if front_times('', 4) == '':
    correct += 1
  if front_times('Abc', 0) == '':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import string_times
def run_tests():
  correct = 0
  total = 10
  if string_times('Hi', 2) == 'HiHi':
    correct += 1
  if string_times('Hi', 3) == 'HiHiHi':
    correct += 1
  if string_times('Hi', 1) == 'Hi':
    correct += 1
  if string_times('Hi', 0) == '':
    correct += 1
  if string_times('Hi', 5) == 'HiHiHiHiHi':
    correct += 1
  if string_times('Oh Boy!', 2) == 'Oh Boy!Oh Boy!':
    correct += 1
  if string_times('x', 4) == 'xxxx':
    correct += 1
  if string_times('', 4) == '':
    correct += 1
  if string_times('code', 2) == 'codecode':
    correct += 1
  if string_times('code', 3) == 'codecodecode':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

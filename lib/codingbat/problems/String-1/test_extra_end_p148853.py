from solution import extra_end
def run_tests():
  correct = 0
  total = 5
  if extra_end('Hello') == 'lololo':
    correct += 1
  if extra_end('ab') == 'ababab':
    correct += 1
  if extra_end('Hi') == 'HiHiHi':
    correct += 1
  if extra_end('Candy') == 'dydydy':
    correct += 1
  if extra_end('Code') == 'dedede':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

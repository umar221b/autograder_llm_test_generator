from solution import sum_double
def run_tests():
  correct = 0
  total = 8
  if sum_double(1, 2) == 3:
    correct += 1
  if sum_double(3, 2) == 5:
    correct += 1
  if sum_double(2, 2) == 8:
    correct += 1
  if sum_double(-1, 0) == -1:
    correct += 1
  if sum_double(3, 3) == 12:
    correct += 1
  if sum_double(0, 0) == 0:
    correct += 1
  if sum_double(0, 1) == 1:
    correct += 1
  if sum_double(3, 4) == 7:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import sum13
def run_tests():
  correct = 0
  total = 14
  if sum13([1, 2, 2, 1]) == 6:
    correct += 1
  if sum13([1, 1]) == 2:
    correct += 1
  if sum13([1, 2, 2, 1, 13]) == 6:
    correct += 1
  if sum13([1, 2, 13, 2, 1, 13]) == 4:
    correct += 1
  if sum13([13, 1, 2, 13, 2, 1, 13]) == 3:
    correct += 1
  if sum13([]) == 0:
    correct += 1
  if sum13([13]) == 0:
    correct += 1
  if sum13([13, 13]) == 0:
    correct += 1
  if sum13([13, 0, 13]) == 0:
    correct += 1
  if sum13([13, 1, 13]) == 0:
    correct += 1
  if sum13([5, 7, 2]) == 14:
    correct += 1
  if sum13([5, 13, 2]) == 5:
    correct += 1
  if sum13([0]) == 0:
    correct += 1
  if sum13([13, 0]) == 0:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

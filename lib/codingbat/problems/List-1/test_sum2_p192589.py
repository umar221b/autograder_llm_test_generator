from solution import sum2
def run_tests():
  correct = 0
  total = 8
  if sum2([1, 2, 3]) == 3:
    correct += 1
  if sum2([1, 1]) == 2:
    correct += 1
  if sum2([1, 1, 1, 1]) == 2:
    correct += 1
  if sum2([1, 2]) == 3:
    correct += 1
  if sum2([1]) == 1:
    correct += 1
  if sum2([]) == 0:
    correct += 1
  if sum2([4, 5, 6]) == 9:
    correct += 1
  if sum2([4]) == 4:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

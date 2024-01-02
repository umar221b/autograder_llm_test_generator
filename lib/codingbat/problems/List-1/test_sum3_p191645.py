from solution import sum3
def run_tests():
  correct = 0
  total = 6
  if sum3([1, 2, 3]) == 6:
    correct += 1
  if sum3([5, 11, 2]) == 18:
    correct += 1
  if sum3([7, 0, 0]) == 7:
    correct += 1
  if sum3([1, 2, 1]) == 4:
    correct += 1
  if sum3([1, 1, 1]) == 3:
    correct += 1
  if sum3([2, 7, 2]) == 11:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

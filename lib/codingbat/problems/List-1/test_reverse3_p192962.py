from solution import reverse3
def run_tests():
  correct = 0
  total = 8
  if reverse3([1, 2, 3]) == [3, 2, 1]:
    correct += 1
  if reverse3([5, 11, 9]) == [9, 11, 5]:
    correct += 1
  if reverse3([7, 0, 0]) == [0, 0, 7]:
    correct += 1
  if reverse3([2, 1, 2]) == [2, 1, 2]:
    correct += 1
  if reverse3([1, 2, 1]) == [1, 2, 1]:
    correct += 1
  if reverse3([2, 11, 3]) == [3, 11, 2]:
    correct += 1
  if reverse3([0, 6, 5]) == [5, 6, 0]:
    correct += 1
  if reverse3([7, 2, 3]) == [3, 2, 7]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

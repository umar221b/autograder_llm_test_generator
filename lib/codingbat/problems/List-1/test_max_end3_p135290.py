from solution import max_end3
def run_tests():
  correct = 0
  total = 8
  if max_end3([1, 2, 3]) == [3, 3, 3]:
    correct += 1
  if max_end3([11, 5, 9]) == [11, 11, 11]:
    correct += 1
  if max_end3([2, 11, 3]) == [3, 3, 3]:
    correct += 1
  if max_end3([11, 3, 3]) == [11, 11, 11]:
    correct += 1
  if max_end3([3, 11, 11]) == [11, 11, 11]:
    correct += 1
  if max_end3([2, 2, 2]) == [2, 2, 2]:
    correct += 1
  if max_end3([2, 11, 2]) == [2, 2, 2]:
    correct += 1
  if max_end3([0, 0, 1]) == [1, 1, 1]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

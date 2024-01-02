from solution import middle_way
def run_tests():
  correct = 0
  total = 6
  if middle_way([1, 2, 3], [4, 5, 6]) == [2, 5]:
    correct += 1
  if middle_way([7, 7, 7], [3, 8, 0]) == [7, 8]:
    correct += 1
  if middle_way([5, 2, 9], [1, 4, 5]) == [2, 4]:
    correct += 1
  if middle_way([1, 9, 7], [4, 8, 8]) == [9, 8]:
    correct += 1
  if middle_way([1, 2, 3], [3, 1, 4]) == [2, 1]:
    correct += 1
  if middle_way([1, 2, 3], [4, 1, 1]) == [2, 1]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

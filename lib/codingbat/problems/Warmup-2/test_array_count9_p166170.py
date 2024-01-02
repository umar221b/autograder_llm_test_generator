from solution import array_count9
def run_tests():
  correct = 0
  total = 7
  if array_count9([1, 2, 9]) == 1:
    correct += 1
  if array_count9([1, 9, 9]) == 2:
    correct += 1
  if array_count9([1, 9, 9, 3, 9]) == 3:
    correct += 1
  if array_count9([1, 2, 3]) == 0:
    correct += 1
  if array_count9([]) == 0:
    correct += 1
  if array_count9([4, 2, 4, 3, 1]) == 0:
    correct += 1
  if array_count9([9, 2, 4, 3, 1]) == 1:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

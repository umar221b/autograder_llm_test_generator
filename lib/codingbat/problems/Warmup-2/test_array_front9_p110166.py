from solution import array_front9
def run_tests():
  correct = 0
  total = 12
  if array_front9([1, 2, 9, 3, 4]) == True:
    correct += 1
  if array_front9([1, 2, 3, 4, 9]) == False:
    correct += 1
  if array_front9([1, 2, 3, 4, 5]) == False:
    correct += 1
  if array_front9([9, 2, 3]) == True:
    correct += 1
  if array_front9([1, 9, 9]) == True:
    correct += 1
  if array_front9([1, 2, 3]) == False:
    correct += 1
  if array_front9([1, 9]) == True:
    correct += 1
  if array_front9([5, 5]) == False:
    correct += 1
  if array_front9([2]) == False:
    correct += 1
  if array_front9([9]) == True:
    correct += 1
  if array_front9([]) == False:
    correct += 1
  if array_front9([3, 9, 2, 3, 3]) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import first_last6
def run_tests():
  correct = 0
  total = 13
  if first_last6([1, 2, 6]) == True:
    correct += 1
  if first_last6([6, 1, 2, 3]) == True:
    correct += 1
  if first_last6([13, 6, 1, 2, 3]) == False:
    correct += 1
  if first_last6([13, 6, 1, 2, 6]) == True:
    correct += 1
  if first_last6([3, 2, 1]) == False:
    correct += 1
  if first_last6([3, 6, 1]) == False:
    correct += 1
  if first_last6([3, 6]) == True:
    correct += 1
  if first_last6([6]) == True:
    correct += 1
  if first_last6([3]) == False:
    correct += 1
  if first_last6([5, 6]) == True:
    correct += 1
  if first_last6([5, 5]) == False:
    correct += 1
  if first_last6([1, 2, 3, 4, 6]) == True:
    correct += 1
  if first_last6([1, 2, 3, 4]) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

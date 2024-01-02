from solution import common_end
def run_tests():
  correct = 0
  total = 5
  if common_end([1, 2, 3], [7, 3]) == True:
    correct += 1
  if common_end([1, 2, 3], [7, 3, 2]) == False:
    correct += 1
  if common_end([1, 2, 3], [1, 3]) == True:
    correct += 1
  if common_end([1, 2, 3], [1]) == True:
    correct += 1
  if common_end([1, 2, 3], [2]) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

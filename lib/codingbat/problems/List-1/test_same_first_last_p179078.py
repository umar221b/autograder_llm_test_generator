from solution import same_first_last
def run_tests():
  correct = 0
  total = 9
  if same_first_last([1, 2, 3]) == False:
    correct += 1
  if same_first_last([1, 2, 3, 1]) == True:
    correct += 1
  if same_first_last([1, 2, 1]) == True:
    correct += 1
  if same_first_last([7]) == True:
    correct += 1
  if same_first_last([]) == False:
    correct += 1
  if same_first_last([1, 2, 3, 4, 5, 1]) == True:
    correct += 1
  if same_first_last([1, 2, 3, 4, 5, 13]) == False:
    correct += 1
  if same_first_last([13, 2, 3, 4, 5, 13]) == True:
    correct += 1
  if same_first_last([7, 7]) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

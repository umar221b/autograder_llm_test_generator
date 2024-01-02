from solution import has23
def run_tests():
  correct = 0
  total = 9
  if has23([2, 5]) == True:
    correct += 1
  if has23([4, 3]) == True:
    correct += 1
  if has23([4, 5]) == False:
    correct += 1
  if has23([2, 2]) == True:
    correct += 1
  if has23([3, 2]) == True:
    correct += 1
  if has23([3, 3]) == True:
    correct += 1
  if has23([7, 7]) == False:
    correct += 1
  if has23([3, 9]) == True:
    correct += 1
  if has23([9, 5]) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

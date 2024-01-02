from solution import has22
def run_tests():
  correct = 0
  total = 14
  if has22([1, 2, 2]) == True:
    correct += 1
  if has22([1, 2, 1, 2]) == False:
    correct += 1
  if has22([2, 1, 2]) == False:
    correct += 1
  if has22([2, 2, 1, 2]) == True:
    correct += 1
  if has22([1, 3, 2]) == False:
    correct += 1
  if has22([1, 3, 2, 2]) == True:
    correct += 1
  if has22([2, 3, 2, 2]) == True:
    correct += 1
  if has22([4, 2, 4, 2, 2, 5]) == True:
    correct += 1
  if has22([1, 2]) == False:
    correct += 1
  if has22([2, 2]) == True:
    correct += 1
  if has22([2]) == False:
    correct += 1
  if has22([]) == False:
    correct += 1
  if has22([3, 3, 2, 2]) == True:
    correct += 1
  if has22([5, 2, 5, 2]) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

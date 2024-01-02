from solution import array123
def run_tests():
  correct = 0
  total = 10
  if array123([1, 1, 2, 3, 1]) == True:
    correct += 1
  if array123([1, 1, 2, 4, 1]) == False:
    correct += 1
  if array123([1, 1, 2, 1, 2, 3]) == True:
    correct += 1
  if array123([1, 1, 2, 1, 2, 1]) == False:
    correct += 1
  if array123([1, 2, 3, 1, 2, 3]) == True:
    correct += 1
  if array123([1, 2, 3]) == True:
    correct += 1
  if array123([1, 1, 1]) == False:
    correct += 1
  if array123([1, 2]) == False:
    correct += 1
  if array123([1]) == False:
    correct += 1
  if array123([]) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

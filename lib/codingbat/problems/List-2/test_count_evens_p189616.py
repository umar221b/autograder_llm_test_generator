from solution import count_evens
def run_tests():
  correct = 0
  total = 8
  if count_evens([2, 1, 2, 3, 4]) == 3:
    correct += 1
  if count_evens([2, 2, 0]) == 3:
    correct += 1
  if count_evens([1, 3, 5]) == 0:
    correct += 1
  if count_evens([]) == 0:
    correct += 1
  if count_evens([11, 9, 0, 1]) == 1:
    correct += 1
  if count_evens([2, 11, 9, 0]) == 2:
    correct += 1
  if count_evens([2]) == 1:
    correct += 1
  if count_evens([2, 5, 12]) == 2:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

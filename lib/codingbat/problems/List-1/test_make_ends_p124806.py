from solution import make_ends
def run_tests():
  correct = 0
  total = 8
  if make_ends([1, 2, 3]) == [1, 3]:
    correct += 1
  if make_ends([1, 2, 3, 4]) == [1, 4]:
    correct += 1
  if make_ends([7, 4, 6, 2]) == [7, 2]:
    correct += 1
  if make_ends([1, 2, 2, 2, 2, 2, 2, 3]) == [1, 3]:
    correct += 1
  if make_ends([7, 4]) == [7, 4]:
    correct += 1
  if make_ends([7]) == [7, 7]:
    correct += 1
  if make_ends([5, 2, 9]) == [5, 9]:
    correct += 1
  if make_ends([2, 3, 4, 1]) == [2, 1]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

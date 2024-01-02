from solution import big_diff
def run_tests():
  correct = 0
  total = 12
  if big_diff([10, 3, 5, 6]) == 7:
    correct += 1
  if big_diff([7, 2, 10, 9]) == 8:
    correct += 1
  if big_diff([2, 10, 7, 2]) == 8:
    correct += 1
  if big_diff([2, 10]) == 8:
    correct += 1
  if big_diff([10, 2]) == 8:
    correct += 1
  if big_diff([10, 0]) == 10:
    correct += 1
  if big_diff([2, 3]) == 1:
    correct += 1
  if big_diff([2, 2]) == 0:
    correct += 1
  if big_diff([2]) == 0:
    correct += 1
  if big_diff([5, 1, 6, 1, 9, 9]) == 8:
    correct += 1
  if big_diff([7, 6, 8, 5]) == 3:
    correct += 1
  if big_diff([7, 7, 6, 8, 5, 5, 6]) == 3:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

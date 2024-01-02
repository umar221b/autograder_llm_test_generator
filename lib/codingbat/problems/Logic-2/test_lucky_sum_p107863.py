from solution import lucky_sum
def run_tests():
  correct = 0
  total = 12
  if lucky_sum(1, 2, 3) == 6:
    correct += 1
  if lucky_sum(1, 2, 13) == 3:
    correct += 1
  if lucky_sum(1, 13, 3) == 1:
    correct += 1
  if lucky_sum(1, 13, 13) == 1:
    correct += 1
  if lucky_sum(6, 5, 2) == 13:
    correct += 1
  if lucky_sum(13, 2, 3) == 0:
    correct += 1
  if lucky_sum(13, 2, 13) == 0:
    correct += 1
  if lucky_sum(13, 13, 2) == 0:
    correct += 1
  if lucky_sum(9, 4, 13) == 13:
    correct += 1
  if lucky_sum(8, 13, 2) == 8:
    correct += 1
  if lucky_sum(7, 2, 1) == 10:
    correct += 1
  if lucky_sum(3, 3, 13) == 6:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import lone_sum
def run_tests():
  correct = 0
  total = 9
  if lone_sum(1, 2, 3) == 6:
    correct += 1
  if lone_sum(3, 2, 3) == 2:
    correct += 1
  if lone_sum(3, 3, 3) == 0:
    correct += 1
  if lone_sum(9, 2, 2) == 9:
    correct += 1
  if lone_sum(2, 2, 9) == 9:
    correct += 1
  if lone_sum(2, 9, 2) == 9:
    correct += 1
  if lone_sum(2, 9, 3) == 14:
    correct += 1
  if lone_sum(4, 2, 3) == 9:
    correct += 1
  if lone_sum(1, 3, 1) == 3:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

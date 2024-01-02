from solution import round_sum
def run_tests():
  correct = 0
  total = 19
  if round_sum(16, 17, 18) == 60:
    correct += 1
  if round_sum(12, 13, 14) == 30:
    correct += 1
  if round_sum(6, 4, 4) == 10:
    correct += 1
  if round_sum(4, 6, 5) == 20:
    correct += 1
  if round_sum(4, 4, 6) == 10:
    correct += 1
  if round_sum(9, 4, 4) == 10:
    correct += 1
  if round_sum(0, 0, 1) == 0:
    correct += 1
  if round_sum(0, 9, 0) == 10:
    correct += 1
  if round_sum(10, 10, 19) == 40:
    correct += 1
  if round_sum(20, 30, 40) == 90:
    correct += 1
  if round_sum(45, 21, 30) == 100:
    correct += 1
  if round_sum(23, 11, 26) == 60:
    correct += 1
  if round_sum(23, 24, 25) == 70:
    correct += 1
  if round_sum(25, 24, 25) == 80:
    correct += 1
  if round_sum(23, 24, 29) == 70:
    correct += 1
  if round_sum(11, 24, 36) == 70:
    correct += 1
  if round_sum(24, 36, 32) == 90:
    correct += 1
  if round_sum(14, 12, 26) == 50:
    correct += 1
  if round_sum(12, 10, 24) == 40:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

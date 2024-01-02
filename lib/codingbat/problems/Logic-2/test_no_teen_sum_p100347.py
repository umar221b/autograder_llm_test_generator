from solution import no_teen_sum
def run_tests():
  correct = 0
  total = 16
  if no_teen_sum(1, 2, 3) == 6:
    correct += 1
  if no_teen_sum(2, 13, 1) == 3:
    correct += 1
  if no_teen_sum(2, 1, 14) == 3:
    correct += 1
  if no_teen_sum(2, 1, 15) == 18:
    correct += 1
  if no_teen_sum(2, 1, 16) == 19:
    correct += 1
  if no_teen_sum(2, 1, 17) == 3:
    correct += 1
  if no_teen_sum(17, 1, 2) == 3:
    correct += 1
  if no_teen_sum(2, 15, 2) == 19:
    correct += 1
  if no_teen_sum(16, 17, 18) == 16:
    correct += 1
  if no_teen_sum(17, 18, 19) == 0:
    correct += 1
  if no_teen_sum(15, 16, 1) == 32:
    correct += 1
  if no_teen_sum(15, 15, 19) == 30:
    correct += 1
  if no_teen_sum(15, 19, 16) == 31:
    correct += 1
  if no_teen_sum(5, 17, 18) == 5:
    correct += 1
  if no_teen_sum(17, 18, 16) == 16:
    correct += 1
  if no_teen_sum(17, 19, 18) == 0:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

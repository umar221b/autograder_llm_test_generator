from solution import sorta_sum
def run_tests():
  correct = 0
  total = 9
  if sorta_sum(3, 4) == 7:
    correct += 1
  if sorta_sum(9, 4) == 20:
    correct += 1
  if sorta_sum(10, 11) == 21:
    correct += 1
  if sorta_sum(12, -3) == 9:
    correct += 1
  if sorta_sum(-3, 12) == 9:
    correct += 1
  if sorta_sum(4, 5) == 9:
    correct += 1
  if sorta_sum(4, 6) == 20:
    correct += 1
  if sorta_sum(14, 7) == 21:
    correct += 1
  if sorta_sum(14, 6) == 20:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

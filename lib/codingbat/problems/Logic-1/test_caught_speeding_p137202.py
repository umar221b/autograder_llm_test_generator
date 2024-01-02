from solution import caught_speeding
def run_tests():
  correct = 0
  total = 12
  if caught_speeding(60, False) == 0:
    correct += 1
  if caught_speeding(65, False) == 1:
    correct += 1
  if caught_speeding(65, True) == 0:
    correct += 1
  if caught_speeding(80, False) == 1:
    correct += 1
  if caught_speeding(85, False) == 2:
    correct += 1
  if caught_speeding(85, True) == 1:
    correct += 1
  if caught_speeding(70, False) == 1:
    correct += 1
  if caught_speeding(75, False) == 1:
    correct += 1
  if caught_speeding(75, True) == 1:
    correct += 1
  if caught_speeding(40, False) == 0:
    correct += 1
  if caught_speeding(40, True) == 0:
    correct += 1
  if caught_speeding(90, False) == 2:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

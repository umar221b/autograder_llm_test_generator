from solution import diff21
def run_tests():
  correct = 0
  total = 12
  if diff21(19) == 2:
    correct += 1
  if diff21(10) == 11:
    correct += 1
  if diff21(21) == 0:
    correct += 1
  if diff21(22) == 2:
    correct += 1
  if diff21(25) == 8:
    correct += 1
  if diff21(30) == 18:
    correct += 1
  if diff21(0) == 21:
    correct += 1
  if diff21(1) == 20:
    correct += 1
  if diff21(2) == 19:
    correct += 1
  if diff21(-1) == 22:
    correct += 1
  if diff21(-2) == 23:
    correct += 1
  if diff21(50) == 58:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

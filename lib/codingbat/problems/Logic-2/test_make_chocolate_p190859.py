from solution import make_chocolate
def run_tests():
  correct = 0
  total = 24
  if make_chocolate(4, 1, 9) == 4:
    correct += 1
  if make_chocolate(4, 1, 10) == -1:
    correct += 1
  if make_chocolate(4, 1, 7) == 2:
    correct += 1
  if make_chocolate(6, 2, 7) == 2:
    correct += 1
  if make_chocolate(4, 1, 5) == 0:
    correct += 1
  if make_chocolate(4, 1, 4) == 4:
    correct += 1
  if make_chocolate(5, 4, 9) == 4:
    correct += 1
  if make_chocolate(9, 3, 18) == 3:
    correct += 1
  if make_chocolate(3, 1, 9) == -1:
    correct += 1
  if make_chocolate(1, 2, 7) == -1:
    correct += 1
  if make_chocolate(1, 2, 6) == 1:
    correct += 1
  if make_chocolate(1, 2, 5) == 0:
    correct += 1
  if make_chocolate(6, 1, 10) == 5:
    correct += 1
  if make_chocolate(6, 1, 11) == 6:
    correct += 1
  if make_chocolate(6, 1, 12) == -1:
    correct += 1
  if make_chocolate(6, 1, 13) == -1:
    correct += 1
  if make_chocolate(6, 2, 10) == 0:
    correct += 1
  if make_chocolate(6, 2, 11) == 1:
    correct += 1
  if make_chocolate(6, 2, 12) == 2:
    correct += 1
  if make_chocolate(60, 100, 550) == 50:
    correct += 1
  if make_chocolate(1000, 1000000, 5000006) == 6:
    correct += 1
  if make_chocolate(7, 1, 12) == 7:
    correct += 1
  if make_chocolate(7, 1, 13) == -1:
    correct += 1
  if make_chocolate(7, 2, 13) == 3:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

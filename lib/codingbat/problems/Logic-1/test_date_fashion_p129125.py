from solution import date_fashion
def run_tests():
  correct = 0
  total = 12
  if date_fashion(5, 10) == 2:
    correct += 1
  if date_fashion(5, 2) == 0:
    correct += 1
  if date_fashion(5, 5) == 1:
    correct += 1
  if date_fashion(3, 3) == 1:
    correct += 1
  if date_fashion(10, 2) == 0:
    correct += 1
  if date_fashion(2, 9) == 0:
    correct += 1
  if date_fashion(9, 9) == 2:
    correct += 1
  if date_fashion(10, 5) == 2:
    correct += 1
  if date_fashion(2, 2) == 0:
    correct += 1
  if date_fashion(3, 7) == 1:
    correct += 1
  if date_fashion(2, 7) == 0:
    correct += 1
  if date_fashion(6, 2) == 0:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

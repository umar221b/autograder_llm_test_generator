from solution import love6
def run_tests():
  correct = 0
  total = 20
  if love6(6, 4) == True:
    correct += 1
  if love6(4, 5) == False:
    correct += 1
  if love6(1, 5) == True:
    correct += 1
  if love6(1, 6) == True:
    correct += 1
  if love6(1, 8) == False:
    correct += 1
  if love6(1, 7) == True:
    correct += 1
  if love6(7, 5) == False:
    correct += 1
  if love6(8, 2) == True:
    correct += 1
  if love6(6, 6) == True:
    correct += 1
  if love6(-6, 2) == False:
    correct += 1
  if love6(-4, -10) == True:
    correct += 1
  if love6(-7, 1) == False:
    correct += 1
  if love6(7, -1) == True:
    correct += 1
  if love6(-6, 12) == True:
    correct += 1
  if love6(-2, -4) == False:
    correct += 1
  if love6(7, 1) == True:
    correct += 1
  if love6(0, 9) == False:
    correct += 1
  if love6(8, 3) == False:
    correct += 1
  if love6(3, 3) == True:
    correct += 1
  if love6(3, 4) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

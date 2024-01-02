from solution import makes10
def run_tests():
  correct = 0
  total = 9
  if makes10(9, 10) == True:
    correct += 1
  if makes10(9, 9) == False:
    correct += 1
  if makes10(1, 9) == True:
    correct += 1
  if makes10(10, 1) == True:
    correct += 1
  if makes10(10, 10) == True:
    correct += 1
  if makes10(8, 2) == True:
    correct += 1
  if makes10(8, 3) == False:
    correct += 1
  if makes10(10, 42) == True:
    correct += 1
  if makes10(12, -2) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

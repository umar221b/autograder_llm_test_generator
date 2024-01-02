from solution import near_ten
def run_tests():
  correct = 0
  total = 15
  if near_ten(12) == True:
    correct += 1
  if near_ten(17) == False:
    correct += 1
  if near_ten(19) == True:
    correct += 1
  if near_ten(31) == True:
    correct += 1
  if near_ten(6) == False:
    correct += 1
  if near_ten(10) == True:
    correct += 1
  if near_ten(11) == True:
    correct += 1
  if near_ten(21) == True:
    correct += 1
  if near_ten(22) == True:
    correct += 1
  if near_ten(23) == False:
    correct += 1
  if near_ten(54) == False:
    correct += 1
  if near_ten(155) == False:
    correct += 1
  if near_ten(158) == True:
    correct += 1
  if near_ten(3) == False:
    correct += 1
  if near_ten(1) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import near_hundred
def run_tests():
  correct = 0
  total = 19
  if near_hundred(93) == True:
    correct += 1
  if near_hundred(90) == True:
    correct += 1
  if near_hundred(89) == False:
    correct += 1
  if near_hundred(110) == True:
    correct += 1
  if near_hundred(111) == False:
    correct += 1
  if near_hundred(121) == False:
    correct += 1
  if near_hundred(-101) == False:
    correct += 1
  if near_hundred(-209) == False:
    correct += 1
  if near_hundred(190) == True:
    correct += 1
  if near_hundred(209) == True:
    correct += 1
  if near_hundred(0) == False:
    correct += 1
  if near_hundred(5) == False:
    correct += 1
  if near_hundred(-50) == False:
    correct += 1
  if near_hundred(191) == True:
    correct += 1
  if near_hundred(189) == False:
    correct += 1
  if near_hundred(200) == True:
    correct += 1
  if near_hundred(210) == True:
    correct += 1
  if near_hundred(211) == False:
    correct += 1
  if near_hundred(290) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

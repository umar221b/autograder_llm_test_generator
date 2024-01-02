from solution import in1to10
def run_tests():
  correct = 0
  total = 15
  if in1to10(5, False) == True:
    correct += 1
  if in1to10(11, False) == False:
    correct += 1
  if in1to10(11, True) == True:
    correct += 1
  if in1to10(10, False) == True:
    correct += 1
  if in1to10(10, True) == True:
    correct += 1
  if in1to10(9, False) == True:
    correct += 1
  if in1to10(9, True) == False:
    correct += 1
  if in1to10(1, False) == True:
    correct += 1
  if in1to10(1, True) == True:
    correct += 1
  if in1to10(0, False) == False:
    correct += 1
  if in1to10(0, True) == True:
    correct += 1
  if in1to10(-1, False) == False:
    correct += 1
  if in1to10(-1, True) == True:
    correct += 1
  if in1to10(99, False) == False:
    correct += 1
  if in1to10(-99, True) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

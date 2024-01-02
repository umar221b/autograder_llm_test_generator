from solution import monkey_trouble
def run_tests():
  correct = 0
  total = 4
  if monkey_trouble(True, True) == True:
    correct += 1
  if monkey_trouble(False, False) == True:
    correct += 1
  if monkey_trouble(True, False) == False:
    correct += 1
  if monkey_trouble(False, True) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import sleep_in
def run_tests():
  correct = 0
  total = 4
  if sleep_in(False, False) == True:
    correct += 1
  if sleep_in(True, False) == False:
    correct += 1
  if sleep_in(False, True) == True:
    correct += 1
  if sleep_in(True, True) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import parrot_trouble
def run_tests():
  correct = 0
  total = 10
  if parrot_trouble(True, 6) == True:
    correct += 1
  if parrot_trouble(True, 7) == False:
    correct += 1
  if parrot_trouble(False, 6) == False:
    correct += 1
  if parrot_trouble(True, 21) == True:
    correct += 1
  if parrot_trouble(False, 21) == False:
    correct += 1
  if parrot_trouble(False, 20) == False:
    correct += 1
  if parrot_trouble(True, 23) == True:
    correct += 1
  if parrot_trouble(False, 23) == False:
    correct += 1
  if parrot_trouble(True, 20) == False:
    correct += 1
  if parrot_trouble(False, 12) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

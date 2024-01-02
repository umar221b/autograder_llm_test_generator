from solution import pos_neg
def run_tests():
  correct = 0
  total = 19
  if pos_neg(1, -1, False) == True:
    correct += 1
  if pos_neg(-1, 1, False) == True:
    correct += 1
  if pos_neg(-4, -5, True) == True:
    correct += 1
  if pos_neg(-4, -5, False) == False:
    correct += 1
  if pos_neg(-4, 5, False) == True:
    correct += 1
  if pos_neg(-4, 5, True) == False:
    correct += 1
  if pos_neg(1, 1, False) == False:
    correct += 1
  if pos_neg(-1, -1, False) == False:
    correct += 1
  if pos_neg(1, -1, True) == False:
    correct += 1
  if pos_neg(-1, 1, True) == False:
    correct += 1
  if pos_neg(1, 1, True) == False:
    correct += 1
  if pos_neg(-1, -1, True) == True:
    correct += 1
  if pos_neg(5, -5, False) == True:
    correct += 1
  if pos_neg(-6, 6, False) == True:
    correct += 1
  if pos_neg(-5, -6, False) == False:
    correct += 1
  if pos_neg(-2, -1, False) == False:
    correct += 1
  if pos_neg(1, 2, False) == False:
    correct += 1
  if pos_neg(-5, 6, True) == False:
    correct += 1
  if pos_neg(-5, -5, True) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

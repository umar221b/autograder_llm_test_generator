from solution import close_far
def run_tests():
  correct = 0
  total = 12
  if close_far(1, 2, 10) == True:
    correct += 1
  if close_far(1, 2, 3) == False:
    correct += 1
  if close_far(4, 1, 3) == True:
    correct += 1
  if close_far(4, 5, 3) == False:
    correct += 1
  if close_far(4, 3, 5) == False:
    correct += 1
  if close_far(-1, 10, 0) == True:
    correct += 1
  if close_far(0, -1, 10) == True:
    correct += 1
  if close_far(10, 10, 8) == True:
    correct += 1
  if close_far(10, 8, 9) == False:
    correct += 1
  if close_far(8, 9, 10) == False:
    correct += 1
  if close_far(8, 9, 7) == False:
    correct += 1
  if close_far(8, 6, 9) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

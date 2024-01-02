from solution import make_bricks
def run_tests():
  correct = 0
  total = 29
  if make_bricks(3, 1, 8) == True:
    correct += 1
  if make_bricks(3, 1, 9) == False:
    correct += 1
  if make_bricks(3, 2, 10) == True:
    correct += 1
  if make_bricks(3, 2, 8) == True:
    correct += 1
  if make_bricks(3, 2, 9) == False:
    correct += 1
  if make_bricks(6, 1, 11) == True:
    correct += 1
  if make_bricks(6, 0, 11) == False:
    correct += 1
  if make_bricks(1, 4, 11) == True:
    correct += 1
  if make_bricks(0, 3, 10) == True:
    correct += 1
  if make_bricks(1, 4, 12) == False:
    correct += 1
  if make_bricks(3, 1, 7) == True:
    correct += 1
  if make_bricks(1, 1, 7) == False:
    correct += 1
  if make_bricks(2, 1, 7) == True:
    correct += 1
  if make_bricks(7, 1, 11) == True:
    correct += 1
  if make_bricks(7, 1, 8) == True:
    correct += 1
  if make_bricks(7, 1, 13) == False:
    correct += 1
  if make_bricks(43, 1, 46) == True:
    correct += 1
  if make_bricks(40, 1, 46) == False:
    correct += 1
  if make_bricks(40, 2, 47) == True:
    correct += 1
  if make_bricks(40, 2, 50) == True:
    correct += 1
  if make_bricks(40, 2, 52) == False:
    correct += 1
  if make_bricks(22, 2, 33) == False:
    correct += 1
  if make_bricks(0, 2, 10) == True:
    correct += 1
  if make_bricks(1000000, 1000, 1000100) == True:
    correct += 1
  if make_bricks(2, 1000000, 100003) == False:
    correct += 1
  if make_bricks(20, 0, 19) == True:
    correct += 1
  if make_bricks(20, 0, 21) == False:
    correct += 1
  if make_bricks(20, 4, 51) == False:
    correct += 1
  if make_bricks(20, 4, 39) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

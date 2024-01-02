from solution import squirrel_play
def run_tests():
  correct = 0
  total = 13
  if squirrel_play(70, False) == True:
    correct += 1
  if squirrel_play(95, False) == False:
    correct += 1
  if squirrel_play(95, True) == True:
    correct += 1
  if squirrel_play(90, False) == True:
    correct += 1
  if squirrel_play(90, True) == True:
    correct += 1
  if squirrel_play(50, False) == False:
    correct += 1
  if squirrel_play(50, True) == False:
    correct += 1
  if squirrel_play(100, False) == False:
    correct += 1
  if squirrel_play(100, True) == True:
    correct += 1
  if squirrel_play(105, True) == False:
    correct += 1
  if squirrel_play(59, False) == False:
    correct += 1
  if squirrel_play(59, True) == False:
    correct += 1
  if squirrel_play(60, False) == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

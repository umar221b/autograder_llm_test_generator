from solution import cat_dog
def run_tests():
  correct = 0
  total = 13
  if cat_dog('catdog') == True:
    correct += 1
  if cat_dog('catcat') == False:
    correct += 1
  if cat_dog('1cat1cadodog') == True:
    correct += 1
  if cat_dog('catxxdogxxxdog') == False:
    correct += 1
  if cat_dog('catxdogxdogxcat') == True:
    correct += 1
  if cat_dog('catxdogxdogxca') == False:
    correct += 1
  if cat_dog('dogdogcat') == False:
    correct += 1
  if cat_dog('dogogcat') == True:
    correct += 1
  if cat_dog('dog') == False:
    correct += 1
  if cat_dog('cat') == False:
    correct += 1
  if cat_dog('ca') == True:
    correct += 1
  if cat_dog('c') == True:
    correct += 1
  if cat_dog('') == True:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

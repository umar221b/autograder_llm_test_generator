from solution import left2
def run_tests():
  correct = 0
  total = 8
  if left2('Hello') == 'lloHe':
    correct += 1
  if left2('java') == 'vaja':
    correct += 1
  if left2('Hi') == 'Hi':
    correct += 1
  if left2('code') == 'deco':
    correct += 1
  if left2('cat') == 'tca':
    correct += 1
  if left2('12345') == '34512':
    correct += 1
  if left2('Chocolate') == 'ocolateCh':
    correct += 1
  if left2('bricks') == 'icksbr':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

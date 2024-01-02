from solution import hello_name
def run_tests():
  correct = 0
  total = 10
  if hello_name('Bob') == 'Hello Bob!':
    correct += 1
  if hello_name('Alice') == 'Hello Alice!':
    correct += 1
  if hello_name('X') == 'Hello X!':
    correct += 1
  if hello_name('Dolly') == 'Hello Dolly!':
    correct += 1
  if hello_name('Alpha') == 'Hello Alpha!':
    correct += 1
  if hello_name('Omega') == 'Hello Omega!':
    correct += 1
  if hello_name('Goodbye') == 'Hello Goodbye!':
    correct += 1
  if hello_name('ho ho ho') == 'Hello ho ho ho!':
    correct += 1
  if hello_name('xyz!') == 'Hello xyz!!':
    correct += 1
  if hello_name('Hello') == 'Hello Hello!':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

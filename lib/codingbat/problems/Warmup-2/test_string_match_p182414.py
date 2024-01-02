from solution import string_match
def run_tests():
  correct = 0
  total = 10
  if string_match('xxcaazz', 'xxbaaz') == 3:
    correct += 1
  if string_match('abc', 'abc') == 2:
    correct += 1
  if string_match('abc', 'axc') == 0:
    correct += 1
  if string_match('hello', 'he') == 1:
    correct += 1
  if string_match('he', 'hello') == 1:
    correct += 1
  if string_match('h', 'hello') == 0:
    correct += 1
  if string_match('', 'hello') == 0:
    correct += 1
  if string_match('aabbccdd', 'abbbxxd') == 1:
    correct += 1
  if string_match('aaxxaaxx', 'iaxxai') == 3:
    correct += 1
  if string_match('iaxxai', 'aaxxaaxx') == 3:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

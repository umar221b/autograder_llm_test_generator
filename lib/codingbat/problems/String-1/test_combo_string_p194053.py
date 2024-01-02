from solution import combo_string
def run_tests():
  correct = 0
  total = 11
  if combo_string('Hello', 'hi') == 'hiHellohi':
    correct += 1
  if combo_string('hi', 'Hello') == 'hiHellohi':
    correct += 1
  if combo_string('aaa', 'b') == 'baaab':
    correct += 1
  if combo_string('b', 'aaa') == 'baaab':
    correct += 1
  if combo_string('aaa', '') == 'aaa':
    correct += 1
  if combo_string('', 'bb') == 'bb':
    correct += 1
  if combo_string('aaa', '1234') == 'aaa1234aaa':
    correct += 1
  if combo_string('aaa', 'bb') == 'bbaaabb':
    correct += 1
  if combo_string('a', 'bb') == 'abba':
    correct += 1
  if combo_string('bb', 'a') == 'abba':
    correct += 1
  if combo_string('xyz', 'ab') == 'abxyzab':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

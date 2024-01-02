from solution import double_char
def run_tests():
  correct = 0
  total = 9
  if double_char('The') == 'TThhee':
    correct += 1
  if double_char('AAbb') == 'AAAAbbbb':
    correct += 1
  if double_char('Hi-There') == 'HHii--TThheerree':
    correct += 1
  if double_char('Word!') == 'WWoorrdd!!':
    correct += 1
  if double_char('!!') == '!!!!':
    correct += 1
  if double_char('') == '':
    correct += 1
  if double_char('a') == 'aa':
    correct += 1
  if double_char('.') == '..':
    correct += 1
  if double_char('aa') == 'aaaa':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

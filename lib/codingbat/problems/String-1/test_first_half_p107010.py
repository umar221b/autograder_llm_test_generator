from solution import first_half
def run_tests():
  correct = 0
  total = 7
  if first_half('WooHoo') == 'Woo':
    correct += 1
  if first_half('HelloThere') == 'Hello':
    correct += 1
  if first_half('abcdef') == 'abc':
    correct += 1
  if first_half('ab') == 'a':
    correct += 1
  if first_half('') == '':
    correct += 1
  if first_half('0123456789') == '01234':
    correct += 1
  if first_half('kitten') == 'kit':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

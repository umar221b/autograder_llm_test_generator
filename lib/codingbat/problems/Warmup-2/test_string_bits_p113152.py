from solution import string_bits
def run_tests():
  correct = 0
  total = 10
  if string_bits('Hello') == 'Hlo':
    correct += 1
  if string_bits('Hi') == 'H':
    correct += 1
  if string_bits('Heeololeo') == 'Hello':
    correct += 1
  if string_bits('HiHiHi') == 'HHH':
    correct += 1
  if string_bits('') == '':
    correct += 1
  if string_bits('Greetings') == 'Getns':
    correct += 1
  if string_bits('Chocoate') == 'Coot':
    correct += 1
  if string_bits('pi') == 'p':
    correct += 1
  if string_bits('Hello Kitten') == 'HloKte':
    correct += 1
  if string_bits('hxaxpxpxy') == 'happy':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

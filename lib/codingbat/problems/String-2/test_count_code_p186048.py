from solution import count_code
def run_tests():
  correct = 0
  total = 14
  if count_code('aaacodebbb') == 1:
    correct += 1
  if count_code('codexxcode') == 2:
    correct += 1
  if count_code('cozexxcope') == 2:
    correct += 1
  if count_code('cozfxxcope') == 1:
    correct += 1
  if count_code('xxcozeyycop') == 1:
    correct += 1
  if count_code('cozcop') == 0:
    correct += 1
  if count_code('abcxyz') == 0:
    correct += 1
  if count_code('code') == 1:
    correct += 1
  if count_code('ode') == 0:
    correct += 1
  if count_code('c') == 0:
    correct += 1
  if count_code('') == 0:
    correct += 1
  if count_code('AAcodeBBcoleCCccoreDD') == 3:
    correct += 1
  if count_code('AAcodeBBcoleCCccorfDD') == 2:
    correct += 1
  if count_code('coAcodeBcoleccoreDD') == 3:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

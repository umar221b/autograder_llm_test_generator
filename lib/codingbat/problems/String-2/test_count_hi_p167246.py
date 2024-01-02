from solution import count_hi
def run_tests():
  correct = 0
  total = 9
  if count_hi('abc hi ho') == 1:
    correct += 1
  if count_hi('ABChi hi') == 2:
    correct += 1
  if count_hi('hihi') == 2:
    correct += 1
  if count_hi('hiHIhi') == 2:
    correct += 1
  if count_hi('') == 0:
    correct += 1
  if count_hi('h') == 0:
    correct += 1
  if count_hi('hi') == 1:
    correct += 1
  if count_hi('Hi is no HI on ahI') == 0:
    correct += 1
  if count_hi('hiho not HOHIhi') == 2:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

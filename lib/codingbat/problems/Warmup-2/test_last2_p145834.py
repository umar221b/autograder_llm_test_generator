from solution import last2
def run_tests():
  correct = 0
  total = 13
  if last2('hixxhi') == 1:
    correct += 1
  if last2('xaxxaxaxx') == 1:
    correct += 1
  if last2('axxxaaxx') == 2:
    correct += 1
  if last2('xxaxxaxxaxx') == 3:
    correct += 1
  if last2('xaxaxaxx') == 0:
    correct += 1
  if last2('xxxx') == 2:
    correct += 1
  if last2('13121312') == 1:
    correct += 1
  if last2('11212') == 1:
    correct += 1
  if last2('13121311') == 0:
    correct += 1
  if last2('1717171') == 2:
    correct += 1
  if last2('hi') == 0:
    correct += 1
  if last2('h') == 0:
    correct += 1
  if last2('') == 0:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import sum67
def run_tests():
  correct = 0
  total = 14
  if sum67([1, 2, 2]) == 5:
    correct += 1
  if sum67([1, 2, 2, 6, 99, 99, 7]) == 5:
    correct += 1
  if sum67([1, 1, 6, 7, 2]) == 4:
    correct += 1
  if sum67([1, 6, 2, 2, 7, 1, 6, 99, 99, 7]) == 2:
    correct += 1
  if sum67([1, 6, 2, 6, 2, 7, 1, 6, 99, 99, 7]) == 2:
    correct += 1
  if sum67([2, 7, 6, 2, 6, 7, 2, 7]) == 18:
    correct += 1
  if sum67([2, 7, 6, 2, 6, 2, 7]) == 9:
    correct += 1
  if sum67([1, 6, 7, 7]) == 8:
    correct += 1
  if sum67([6, 7, 1, 6, 7, 7]) == 8:
    correct += 1
  if sum67([6, 8, 1, 6, 7]) == 0:
    correct += 1
  if sum67([]) == 0:
    correct += 1
  if sum67([6, 7, 11]) == 11:
    correct += 1
  if sum67([11, 6, 7, 11]) == 22:
    correct += 1
  if sum67([2, 2, 6, 7, 7]) == 11:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

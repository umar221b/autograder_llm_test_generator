from solution import centered_average
def run_tests():
  correct = 0
  total = 16
  if centered_average([1, 2, 3, 4, 100]) == 3:
    correct += 1
  if centered_average([1, 1, 5, 5, 10, 8, 7]) == 5:
    correct += 1
  if centered_average([-10, -4, -2, -4, -2, 0]) == -3:
    correct += 1
  if centered_average([5, 3, 4, 6, 2]) == 4:
    correct += 1
  if centered_average([5, 3, 4, 0, 100]) == 4:
    correct += 1
  if centered_average([100, 0, 5, 3, 4]) == 4:
    correct += 1
  if centered_average([4, 0, 100]) == 4:
    correct += 1
  if centered_average([0, 2, 3, 4, 100]) == 3:
    correct += 1
  if centered_average([1, 1, 100]) == 1:
    correct += 1
  if centered_average([7, 7, 7]) == 7:
    correct += 1
  if centered_average([1, 7, 8]) == 7:
    correct += 1
  if centered_average([1, 1, 99, 99]) == 50:
    correct += 1
  if centered_average([1000, 0, 1, 99]) == 50:
    correct += 1
  if centered_average([4, 4, 4, 4, 5]) == 4:
    correct += 1
  if centered_average([4, 4, 4, 1, 5]) == 4:
    correct += 1
  if centered_average([6, 4, 8, 12, 3]) == 6:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

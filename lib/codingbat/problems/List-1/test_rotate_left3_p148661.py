from solution import rotate_left3
def run_tests():
  correct = 0
  total = 5
  if rotate_left3([1, 2, 3]) == [2, 3, 1]:
    correct += 1
  if rotate_left3([5, 11, 9]) == [11, 9, 5]:
    correct += 1
  if rotate_left3([7, 0, 0]) == [0, 0, 7]:
    correct += 1
  if rotate_left3([1, 2, 1]) == [2, 1, 1]:
    correct += 1
  if rotate_left3([0, 0, 1]) == [0, 1, 0]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

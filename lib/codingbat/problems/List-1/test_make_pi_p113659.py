from solution import make_pi
def run_tests():
  correct = 0
  total = 1
  if make_pi() == [3, 1, 4]:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

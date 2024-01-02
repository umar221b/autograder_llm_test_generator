from solution import missing_char
def run_tests():
  correct = 0
  total = 10
  if missing_char('kitten', 1) == 'ktten':
    correct += 1
  if missing_char('kitten', 0) == 'itten':
    correct += 1
  if missing_char('kitten', 4) == 'kittn':
    correct += 1
  if missing_char('Hi', 0) == 'i':
    correct += 1
  if missing_char('Hi', 1) == 'H':
    correct += 1
  if missing_char('code', 0) == 'ode':
    correct += 1
  if missing_char('code', 1) == 'cde':
    correct += 1
  if missing_char('code', 2) == 'coe':
    correct += 1
  if missing_char('code', 3) == 'cod':
    correct += 1
  if missing_char('chocolate', 8) == 'chocolat':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

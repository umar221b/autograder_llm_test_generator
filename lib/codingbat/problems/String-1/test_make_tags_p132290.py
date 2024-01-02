from solution import make_tags
def run_tests():
  correct = 0
  total = 7
  if make_tags('i', 'Yay') == '<i>Yay</i>':
    correct += 1
  if make_tags('i', 'Hello') == '<i>Hello</i>':
    correct += 1
  if make_tags('cite', 'Yay') == '<cite>Yay</cite>':
    correct += 1
  if make_tags('address', 'here') == '<address>here</address>':
    correct += 1
  if make_tags('body', 'Heart') == '<body>Heart</body>':
    correct += 1
  if make_tags('i', 'i') == '<i>i</i>':
    correct += 1
  if make_tags('i', '') == '<i></i>':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

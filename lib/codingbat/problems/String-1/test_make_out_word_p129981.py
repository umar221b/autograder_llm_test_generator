from solution import make_out_word
def run_tests():
  correct = 0
  total = 5
  if make_out_word('<<>>', 'Yay') == '<<Yay>>':
    correct += 1
  if make_out_word('<<>>', 'WooHoo') == '<<WooHoo>>':
    correct += 1
  if make_out_word('[[]]', 'word') == '[[word]]':
    correct += 1
  if make_out_word('HHoo', 'Hello') == 'HHHellooo':
    correct += 1
  if make_out_word('abyz', 'YAY') == 'abYAYyz':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

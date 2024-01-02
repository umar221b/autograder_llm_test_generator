from solution import without_end
def run_tests():
  correct = 0
  total = 8
  if without_end('Hello') == 'ell':
    correct += 1
  if without_end('java') == 'av':
    correct += 1
  if without_end('coding') == 'odin':
    correct += 1
  if without_end('code') == 'od':
    correct += 1
  if without_end('ab') == '':
    correct += 1
  if without_end('Chocolate!') == 'hocolate':
    correct += 1
  if without_end('kitten') == 'itte':
    correct += 1
  if without_end('woohoo') == 'ooho':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import string_splosion
def run_tests():
  correct = 0
  total = 10
  if string_splosion('Code') == 'CCoCodCode':
    correct += 1
  if string_splosion('abc') == 'aababc':
    correct += 1
  if string_splosion('ab') == 'aab':
    correct += 1
  if string_splosion('x') == 'x':
    correct += 1
  if string_splosion('fade') == 'ffafadfade':
    correct += 1
  if string_splosion('There') == 'TThTheTherThere':
    correct += 1
  if string_splosion('Kitten') == 'KKiKitKittKitteKitten':
    correct += 1
  if string_splosion('Bye') == 'BByBye':
    correct += 1
  if string_splosion('Good') == 'GGoGooGood':
    correct += 1
  if string_splosion('Bad') == 'BBaBad':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import make_abba
def run_tests():
  correct = 0
  total = 9
  if make_abba('Hi', 'Bye') == 'HiByeByeHi':
    correct += 1
  if make_abba('Yo', 'Alice') == 'YoAliceAliceYo':
    correct += 1
  if make_abba('What', 'Up') == 'WhatUpUpWhat':
    correct += 1
  if make_abba('aaa', 'bbb') == 'aaabbbbbbaaa':
    correct += 1
  if make_abba('x', 'y') == 'xyyx':
    correct += 1
  if make_abba('x', '') == 'xx':
    correct += 1
  if make_abba('', 'y') == 'yy':
    correct += 1
  if make_abba('Bo', 'Ya') == 'BoYaYaBo':
    correct += 1
  if make_abba('Ya', 'Ya') == 'YaYaYaYa':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

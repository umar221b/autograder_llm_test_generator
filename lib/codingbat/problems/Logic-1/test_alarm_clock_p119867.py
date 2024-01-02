from solution import alarm_clock
def run_tests():
  correct = 0
  total = 9
  if alarm_clock(1, False) == '7:00':
    correct += 1
  if alarm_clock(5, False) == '7:00':
    correct += 1
  if alarm_clock(0, False) == '10:00':
    correct += 1
  if alarm_clock(6, False) == '10:00':
    correct += 1
  if alarm_clock(0, True) == 'off':
    correct += 1
  if alarm_clock(6, True) == 'off':
    correct += 1
  if alarm_clock(1, True) == '10:00':
    correct += 1
  if alarm_clock(3, True) == '10:00':
    correct += 1
  if alarm_clock(5, True) == '10:00':
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

from solution import cigar_party
def run_tests():
  correct = 0
  total = 11
  if cigar_party(30, False) == False:
    correct += 1
  if cigar_party(50, False) == True:
    correct += 1
  if cigar_party(70, True) == True:
    correct += 1
  if cigar_party(30, True) == False:
    correct += 1
  if cigar_party(50, True) == True:
    correct += 1
  if cigar_party(60, False) == True:
    correct += 1
  if cigar_party(61, False) == False:
    correct += 1
  if cigar_party(40, False) == True:
    correct += 1
  if cigar_party(39, False) == False:
    correct += 1
  if cigar_party(40, True) == True:
    correct += 1
  if cigar_party(39, True) == False:
    correct += 1
  print(f"{correct} / {total} successful tests")
run_tests()

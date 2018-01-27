a = Array.new(5)
init = 0
while init < a.length
  a[init] = Array.new(7, "0")
  init += 1
end
i = 0
r = 0
c = 0
s = "11111100011111110101111111010111111"
puts s.length
pointer = 0
while i < s.length
  a[r][c] = s[i]
  puts a.to_s
  r += 1
  i += 1
  if r > a.length - 1
    r = 0
    c += 1
  end
end
i = 0
r = 0
c = 0
puts a[0]
puts a[0].length
while c < a[0].length
  if r%2 == 0 && c % 2 == 0
    print "+ "
  elsif r%2 == 0 && c % 2 != 0 && a[r][c] == "1"
    print "| "
  elsif r%2 != 0 && c % 2 == 0 && a[r][c] == "1"
    print "- "
  else
    print "  "
  end
  r += 1
  if r > a.length - 1
    print "\n"
    c += 1
    r = 0
  end
end
#a[0][0] = 3
#puts a.to_s
#a[0][1] = 4
#puts a.to_s

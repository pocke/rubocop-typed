a = {a: { b: 1 } }
p a[:a][:b]

b = {a: [{b: 1}]}
p b[:a][0][:b]

c = nil
c[:a][:b]

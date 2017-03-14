using Perseus
t = 0:0.1:2pi
x, y = cos(t), sin(t)
data = hcat([x y]', [x + 3.5 y]')
b = Perseus.perseus(data; g = 0, s = 0.1, N = 5, C = 2, plot = true)

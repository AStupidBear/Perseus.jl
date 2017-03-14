using Perseus
c, a, N = 1, 0.3, 30
t = linspace(0, 2π, N)
u, v = repeat(t, outer = N), repeat(t, inner = N)
x, y, z = (c + a * cos(v)) .* cos(u), (c + a * cos(v)) .* sin(u), a * sin(v)
data = [x y z]'
b = Perseus.perseus(data, g = 0, s = 0.01, N = 50, C = 2, plot = true)

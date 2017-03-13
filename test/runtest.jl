include("../src/Perseus.jl")
t = 0:0.1:2pi; x = cos(t); y = sin(t)
data = hcat([x y]',[x+3.5 y]')
b = Perseus.perseus(data; g=0, s=0.1, N=5, C=2, plot=true)


c = 1; a = 0.3; N = 30
t = linspace(0, 2π, N)
u = repeat(t, outer=N)
v = repeat(t, inner=N)
x = (c + a*cos(v)).*cos(u)
y = (c + a*cos(v)).*sin(u)
z = a*sin(v)
data = [x y z]'
include("../src/Perseus.jl")
b = Perseus.perseus(data, g=0, s=0.01, N=50, C=2, plot=true)

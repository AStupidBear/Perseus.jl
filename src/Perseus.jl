module Perseus

using Gadfly, DataFrames

function perseus(data; o...)
  M = size(data, 2)
  D = zeros(M, M)
  D = [norm(data[:, i] - data[:, j]) for i = 1:M, j = 1:M]
  distmat(D; o...)
end

"""
    initial threshold distance g = 0.1,
    step size s = 0.2,
    number of steps N = 5
    dimension cap C = 2
"""
function distmat(D; g = 0, s = 0.2, N = 5, C = 2, plot = false, remove = true)
  open("distmat.txt", "w") do f
    println(f, size(D, 1))
    writedlm(f, [g s N C], ' ')
    writedlm(f, D, ' ')
  end
  path = normpath(joinpath(dirname(@__FILE__), "..", "deps"))
  @static if is_windows()
    run(`$path/perseusWin.exe distmat distmat.txt`)
  elseif is_unix()
    run(`$path/perseusLin distmat distmat.txt`)
  end
  plot == true && persdia(N, C, s)
  b = betti(C)
  remove == true && clean()
  return b
end

function persdia(N, C, s)
  df = DataFrame()

  for b = 0:(C - 1)
    A = nothing
    try  A = readdlm("output_$b.txt")
    catch break
    end
    for row = 1:size(A, 1)
      A[row,2] == -1 && (A[row,2] = N)
      df = vcat(df, DataFrame(birth = s * A[row, 1],
          death = s * A[row, 2], BettiNumber = "$b"))
    end
  end

  l1 = layer(df, x = :birth, y = :death, color = :BettiNumber, Geom.beeswarm)
  l2 = layer(x = [0, N * s], ymin = [0, 0], ymax = [0, N * s], Geom.ribbon)
  plot(l1[1], l2[1], Theme(default_point_size = 1.5pt)) |> display
end

function betti(C)
  B = Int.(readdlm("output_betti.txt")[:, 1:C+1])
  b = [(B[1, 2:(C + 1)]...)]
  span = [0]
  for row in 2:size(B, 1)
    if B[row, 2:(C + 1)] == B[row-1, 2:(C + 1)]
      span[end] += B[row, 1] - B[row - 1, 1]
    else
      push!(b, (B[row, 2:(C + 1)]...))
      push!(span, 0)
    end
  end
  b[indmax(span)]
end

function clean()
  try run(`rm output*.txt`) end
  try run(`rm distmat.txt`) end
end

end

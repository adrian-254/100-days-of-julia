#Fibonacci in julia
f(n) = n < 2 ? 1 : f(n - 1) + f(n - 2)
for i = 0:10 
    println("(f($i) = $(f(i)))")
end
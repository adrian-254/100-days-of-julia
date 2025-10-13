#A quadratic equation solver
println("Enter coefficient 'A'")
A = (Int64, readline())
println("Enter coefficient 'B'")
B =(Int64, readline())
println("Enter Coefficient 'C'")
C = (Int64, readline())

D = B ^ 2 - 4*A*C  #discriminatns

if D > 0
    x1= (-B + sqrt(D)) / (2 * A)
    x1= (-B - sqrt(D)) / (2 * A)
    println("Two real roots:", x1, " and ", x2)
elseif D == 0
    x = -B / (2 * A)
    println("One Real root", x)
else 
    println("No real Roots")
end


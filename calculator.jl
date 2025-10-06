#Calculator 
println("enter first number")
a = parse(Float64, readline())
println("Enter Operator(+, -, *, /, ^, sqrt)")
op = readline()

if op!= "sqrt"
    println("Enter Second Number")
b = parse(Float64, readline())
end

if op == "+"
    println("Result: ", a + b)
elseif op == "-"
    println("Result: ", a - b)
elseif op == "*"
    println("Result: ", a * b)
elseif op == "/"
    println("Result: ", a / b)
elseif op == "^"
    println("Result: ", a ^ b)
elseif op == "sqrt"
    println("Result is ", a ^ 0.5)
else println("Invalid Operator")
end
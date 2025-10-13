#A manual polynomial evaluator, writing a function that takes co efficients and an x value and computes g(x)

function eval_poly(coefficients, x)
    # coefficients = [a_n, a_{n-1}, ..., a_0]
    result = 0
    for (i ,a) in enumerate(coefficients)
        result += a * x ^(length(coefficients)- i) #The coefficient is determined by how many elements is passed inside the array
    end
    return result
end

# Example: -1/4^2 + 7 → coeffs = [-1/4, 0, 7]

println(eval_poly([-1/4, 0, 7], 4))


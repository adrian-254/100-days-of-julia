#All basic arithmetics just work the same as other languages so we're gonna do the more complex ones

#Remainder
x = 3
y = 2
println(x % y)


#exponential form
a = 4
b = 5
println(a ^ b)

#Rational form
c = 10
d = 3
println(c // d)

#floor division > Returning of a whole number on a decimal result
f = 13
g = 2
println(f ÷ g)


#Broadcasted versions > applying operation element-wise across arrays
println([1,2,3] .+ [4,5,6])
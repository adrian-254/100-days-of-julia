#!/usr/bin/env julia

# --------- Aliases (normalize human input) ----------
const ALIAS = Dict{String,String}(
    # length
    "m"=>"m","meter"=>"m","meters"=>"m",
    "km"=>"km","kilometer"=>"km","kilometers"=>"km",
    "cm"=>"cm","centimeter"=>"cm","centimeters"=>"cm",
    "mm"=>"mm","millimeter"=>"mm","millimeters"=>"mm",
    "mi"=>"mi","mile"=>"mi","miles"=>"mi",
    "ft"=>"ft","foot"=>"ft","feet"=>"ft",
    "in"=>"in","inch"=>"in","inches"=>"in",

    # mass
    "kg"=>"kg","kilogram"=>"kg","kilograms"=>"kg",
    "g"=>"g","gram"=>"g","grams"=>"g",
    "lb"=>"lb","lbs"=>"lb","pound"=>"lb","pounds"=>"lb",
    "oz"=>"oz","ounce"=>"oz","ounces"=>"oz",

    # temperature
    "c"=>"c","°c"=>"c","degc"=>"c","celsius"=>"c","centigrade"=>"c",
    "f"=>"f","°f"=>"f","degf"=>"f","fahrenheit"=>"f",
    "k"=>"k","kelvin"=>"k"
)

# --------- Unit families & factors to base unit ----------
# Base units: length -> meter, mass -> kilogram
const LENGTH_FACTORS = Dict(
    "m"=>1.0,
    "km"=>1000.0,
    "cm"=>0.01,
    "mm"=>0.001,
    "mi"=>1609.344,
    "ft"=>0.3048,
    "in"=>0.0254
)

const MASS_FACTORS = Dict(
    "kg"=>1.0,
    "g"=>0.001,
    "lb"=>0.45359237,
    "oz"=>0.028349523125
)

# Helper: lowercase + trim + alias map
normalize_unit(u::AbstractString) = get(ALIAS, lowercase(strip(u)), lowercase(strip(u)))

# --------- Converters ----------
# length/mass share factor-to-base conversion
function convert_by_factor(x::Real, from::String, to::String, table::Dict{String,Float64})
    haskey(table, from) || error("Unsupported unit: $from")
    haskey(table, to)   || error("Unsupported unit: $to")
    x * table[from] / table[to]
end

# temperature needs formulas
function convert_temperature(x::Real, from::String, to::String)
    f = from; t = to
    f == t && return float(x)
    # to Kelvin as hub
    toK = f == "c" ? (x + 273.15) :
          f == "f" ? ((x - 32) * 5/9 + 273.15) :
          f == "k" ? x :
          error("Unsupported temperature unit: $from")
    fromK = t == "c" ? (toK - 273.15) :
            t == "f" ? ((toK - 273.15) * 9/5 + 32) :
            t == "k" ? toK :
            error("Unsupported temperature unit: $to")
    return fromK
end

# Detect family by membership
function family_of(u::String)
    if haskey(LENGTH_FACTORS, u) return :length end
    if haskey(MASS_FACTORS, u)   return :mass   end
    if u in ("c","f","k")        return :temp   end
    return :unknown
end

function convert_unit(x::Real, from_raw::AbstractString, to_raw::AbstractString)
    from = normalize_unit(from_raw)
    to   = normalize_unit(to_raw)

    fam_from = family_of(from)
    fam_to   = family_of(to)
    fam_from == fam_to || error("Incompatible units: '$from_raw' → '$to_raw'")

    if fam_from == :length
        return convert_by_factor(x, from, to, LENGTH_FACTORS)
    elseif fam_from == :mass
        return convert_by_factor(x, from, to, MASS_FACTORS)
    elseif fam_from == :temp
        return convert_temperature(x, from, to)
    else
        error("Unknown unit(s): $from_raw, $to_raw")
    end
end

# --------- CLI / Prompt ----------
function main()
    if length(ARGS) == 3
        x = parse(Float64, ARGS[0])
        fromu = ARGS[1]; tou = ARGS[2]
        y = convert_unit(x, fromu, tou)
        println(y)
    else
        println("Unit Converter (length, mass, temperature)")
        print("Value: "); x = parse(Float64, readline(stdin))
        print("From unit (e.g., km, m, lb, c): "); fromu = readline(stdin)
        print("To unit   (e.g., m,  cm, kg, f): "); tou = readline(stdin)
        y = convert_unit(x, fromu, tou)
        println("Result: $y")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    try
        main()
    catch e
        @error string(e)
        println("Tip: Examples →")
        println("  julia unit_converter.jl 12 km m      # 12000")
        println("  julia unit_converter.jl 72 f c       # 22.2222...")
        println("  julia unit_converter.jl 5 lb kg      # 2.26796...")
        exit(1)
    end
end

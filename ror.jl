using CSV
using Random
using Statistics
using DataFrames
using Distributions

# Read the data from the CSV file
path = "/Users/cavendish/Documents/山财文档/研一下学期/实习/ror/"
data_index = CSV.read(joinpath(path, "data_index.csv"), DataFrame)[:, 3] .+ 1
data_mao = CSV.read(joinpath(path, "data_mao.csv"), DataFrame)[:, 3] .+ 1
data_meng = CSV.read(joinpath(path, "data_meng.csv"), DataFrame)[:, 3] .+ 1

# Choose data
day_return = data_index

# Define investor struct
struct Investors
    invest_level::Float64
    invest_freq::Float64
    hold::Int64
    num_inv::Int64
    trans_cost::Float64
end

function rors(investor::Investors, day_return::Array{Float64, 1})
    """
    Calculate the rate of return (ROR) for a given investment strategy.

    Parameters:
    investor (Investors): The investor's parameters.
    day_return (Array{Float64, 1}): The data to use for the ROR calculation.

    Returns:
    Array{Float64, 1}: An array of RORs.
    """
    # Initialize RORs
    rors = Float64[]

    # Calculate the number of holding periods
    num_period = length(day_return) ÷ investor.hold

    # Calculate the return of each period
    period_returns = prod(reshape(day_return[1:num_period * investor.hold], (num_period, investor.hold)), dims=2)
    if length(day_return) % investor.hold != 0
        period_returns = vcat(period_returns, prod(day_return[num_period * investor.hold + 1:end]))
    end

    # Get the rightful invest strategy
    right_invest = period_returns .> 1

    for i in 1:investor.num_inv
        # Generate consider vector
        num_consid = round(investor.invest_freq * length(period_returns))
        consider = rand(Bernoulli(investor.invest_freq), length(period_returns))

        # Generate invest vector
        invest = rand(Bernoulli(investor.invest_level), length(period_returns)) .== right_invest

        invest_return = period_returns[consider .& invest]

        ror = prod(invest_return)

        # Consider transaction cost
        ror = (1 - investor.trans_cost) ^ length(invest_return) * ror

        # Calculate RORs using vectorized operations
        push!(rors, ror)
    end

    # Return RORs
    return rors
end

long_return = rors(Investors(1, 1, length(day_return), 1, 0.001), day_return)[1]
best_return = rors(Investors(1, 1, 1, 1, 0.001), day_return)[1]
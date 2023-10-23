import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Define function to generate RORs
def gen_RORs(day_return_data, ror_num=100, invest_level=0.5, invest_freq=1, hold=1, trans_cost=0.001):
    # Get period returns
    period_returns = np.prod(np.append(day_return_data, np.ones(-len(day_return_data) % hold)).reshape(-1, hold), axis=1)
    # Define function to generate ROR
    def gen_ROR():
        # Get focusing periods
        focusing_periods = np.random.choice((True, False), size=len(period_returns), p=(invest_freq, 1 - invest_freq))
        # Get if invest or not
        if_invest = np.random.choice((True, False), size=len(period_returns), p=(invest_level, 1 - invest_level)) == (period_returns > 1)
        # Get ROR
        return np.prod(period_returns[focusing_periods & if_invest] * (1 - trans_cost))
    return np.array([gen_ROR() for _ in range(ror_num)])

# Define function to plot ROR line chart with error bars
def line_with_error_bar(data_name, k_sd=0.2, var_name="Invest Level", x=np.linspace(0.4, 0.6, num=20), fun=lambda x : gen_RORs(day_return_data, invest_level=x)):
    mean_RORs = np.array([np.mean(fun(x)) for x in x])
    std_RORs = np.array([np.std(fun(x)) for x in x])
    plt.figure()
    plt.plot(x, mean_RORs)
    plt.errorbar(x=x, y=mean_RORs, yerr=k_sd * std_RORs)
    plt.title(f"Mean ROR vs {var_name} with Error Bars")
    plt.xlabel(var_name)
    plt.ylabel("Mean ROR")
    plt.savefig(f"./pyplots/{data_name}/Mean ROR vs {var_name}.png")
    plt.close()

# Define function to plot different arguments of ROR
def plot_RORs(data_name="index"):
    # Import data
    day_return_data = pd.read_csv(f"./data_{data_name}.csv").iloc[:, 2].values + 1
    # Plot RORs
    line_with_error_bar(data_name, var_name="Invest Level", x=np.linspace(0.4, 0.6, num=20), fun=lambda x : gen_RORs(day_return_data, invest_level=x))
    line_with_error_bar(data_name, var_name="Invest Frequency", x=np.linspace(0, 1, num=20), fun=lambda x : gen_RORs(day_return_data, invest_freq=x))
    line_with_error_bar(data_name, var_name="Holding Period", x=np.linspace(1, len(day_return_data), num=20, dtype=int), fun=lambda x : gen_RORs(day_return_data, hold=x))

plot_RORs("index")
plot_RORs("maotai")
plot_RORs("mengjie")

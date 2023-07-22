import os
import pandas as pd
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

# Read the data from the CSV file
path = "~/Desktop/ror/"
data_index = pd.read_csv(os.path.join(path, "data_index.csv")).iloc[:, 2].values + 1
data_mao = pd.read_csv(os.path.join(path, "data_mao.csv")).iloc[:, 2].values + 1
data_meng = pd.read_csv(os.path.join(path, "data_meng.csv")).iloc[:, 2].values + 1

# Choose data
day_return = data_index

# Define investor class
class Investors:
    def __init__(self, invest_level=0.5, invest_freq=1, hold=1, num_inv=1000, trans_cost=0.001):
        """
        Initialize the investor class with default parameters.

        Parameters:
        invest_level (float): The investor's investment level.
        invest_freq (float): The investor's investment frequency.
        hold (int): The investor's holding period.
        num_inv (int): The number of investors to simulate.
        trans_cost (float): The transaction cost to consider.
        """
        self.invest_level = invest_level
        self.invest_freq = invest_freq
        self.hold = hold
        self.num_inv = num_inv
        self.trans_cost = trans_cost

    def rors(self, day_return=day_return):
        """
        Calculate the rate of return (ROR) for a given investment strategy.

        Parameters:
        day_return (numpy.ndarray): The data to use for the ROR calculation.

        Returns:
        numpy.ndarray: An array of RORs.
        """
        # Initialize RORs
        rors = np.array([])

        # Calculate the number of holding periods
        num_period = len(day_return) // self.hold

        # Calculate the return of each period
        period_returns = np.prod(day_return[:num_period * self.hold].reshape(-1, self.hold), axis=1)
        if len(day_return) % self.hold != 0:
            period_returns = np.append(period_returns, np.prod(day_return[num_period * self.hold:]))

        # Get the rightful invest strategy
        right_invest = period_returns > 1

        for i in range(self.num_inv):
            # Generate consider vector
            num_consid = round(self.invest_freq * len(period_returns))
            consider = np.random.binomial(1, self.invest_freq, len(period_returns)).astype(bool)

            # Generate invest vector
            invest = np.random.binomial(1, self.invest_level, len(period_returns)).astype(bool)
            invest = invest == right_invest

            invest_return = period_returns[consider & invest]

            ror = np.prod(invest_return)

            # Consider transaction cost
            ror = (1 - self.trans_cost) ** len(invest_return) * ror

            # Calculate RORs using vectorized operations
            rors = np.append(rors, ror)

        # Return RORs
        return rors

long_return = Investors(invest_level = 1, invest_freq = 1, hold = len(day_return), num_inv = 1).rors()[0]
best_return = Investors(invest_level = 1, invest_freq = 1, hold = 1, num_inv = 1).rors()[0]



# DENSITY DIAGRAM

# Simulate RORs to plot density diagram
investor = Investors(invest_level=0.5, invest_freq=1, hold=1, num_inv=10000, trans_cost=0.001)
rors = investor.rors()

# Calculate data for density diagram
x = np.linspace(rors.min(), rors.max(), 200)
y = stats.gaussian_kde(rors)(x)

# Plot density diagram and lines
plt.figure()
plt.plot(x, y, color="blue")
plt.axvline(x=1, color="red")
plt.axvline(x=long_return, color="green")

# Add legends
plt.title("Density of ROR")
plt.xlabel("ROR")
plt.ylabel("Density")
plt.legend(
    [
        f"Invest Level: {investor.invest_level}\n"
        f"Invest Frequency: {investor.invest_freq}\n"
        f"Holding Period: {investor.hold} day(s)\n"
        f"Number of Investors: {investor.num_inv}\n"
        f"Mean: {round(np.mean(rors), 4)}",
        "x = 1",
        f"Hold for 10 years: x = {round(long_return, 4)}"
    ],
    loc="upper right"
)

# Save the plot to a file
plt.savefig("~/Desktop/ROR_density.png")

# Close the plot
plt.close()
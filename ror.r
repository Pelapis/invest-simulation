# Import libraries
library(graphics)

# Import data from csv file
data_index <- read.csv("~/data_index.csv")[, 3] + 1
data_mao <- read.csv("~/data_mao.csv")[, 3] + 1
data_meng <- read.csv("~/data_meng.csv")[, 3] + 1

# Select data to use
day_return <- data_index

# Define function to generate ROR for a given investment strategy
gen_rors <- function(day_returns = day_return, num_ror = 1000, invest_level = 0.5, invest_freq = 1, hold = 1, trans_cost = 0.001) {
    # Period returns
    gen_period_returns <- function(day_returns = day_returns, hold = hold) {
        day_returns_add <- c(day_returns, rep(1, times = day_returns %% hold))
        day_returns_matrix <- matrix(day_returns_add, nrow = hold)
        period_returns <- apply(day_returns_matrix, 2, prod)
        period_returns
    }
    period_returns <- gen_period_returns(day_returns = day_returns, hold = hold)

    # Focusing periods
    gen_focusing_periods <- function(returns = period_returns, invest_freq = invest_freq)
        sample(c(TRUE, FALSE), size = length(returns), replace = TRUE, prob = c(invest_freq, 1 - invest_freq))

    # RORs
    RORs <- replicate(num_ror, {
        focusing_periods <- gen_focusing_periods(returns = period_returns, invest_freq = invest_freq)
        if_invest <- sample(c(TRUE, FALSE), size = length(period_returns), replace = TRUE, prob = c(invest_level, 1 - invest_level)) == (period_returns > 1)
        prod((period_returns * (1 - trans_cost))[focusing_periods & if_invest])
    })
    RORs
}



# BOXPLOT OF ROR WITH DIFFERENT INVEST LEVELS

# Set the max number, invest_freq and invest_level
num_ror <- 1000
invest_freq <- 1

# Simulate RORs with different invest levels, and plot the boxplot diagram
png("/Users/cavendish/Desktop/不同投资水平的ROR箱线图.png")
boxplot(
    gen_rors(day_return, num_ror, 0.475, invest_freq),
    gen_rors(day_return, num_ror, 0.5, invest_freq),
    gen_rors(day_return, num_ror, 0.525, invest_freq),
    gen_rors(day_return, num_ror, 0.55, invest_freq),
    gen_rors(day_return, num_ror, 0.56, invest_freq),
    gen_rors(day_return, num_ror, 0.575, invest_freq),
    main = "Boxplot of ROR with different invest levels",
    xlab = "Invest Level",
    ylab = "ROR",
    names = c("0.475", "0.5", "0.525", "0.55", "0.56", "0.575")
    )
# Add a y = 1.5346 line
abline(h = 1.5346, col = "red")
# Add a legend of num_ror, invest level and the line
legend(
    "topleft",
    legend = c(
        paste("Numbers:", num_ror),
        paste("Invest frequency:", invest_freq),
        paste("Hold for 10 years ROR = 1.5346")
    ),
    col = c("black", "black", "red"),
    lty = c(1, 1, 1), cex = 0.8
)
dev.off()



# CURVE OF MEAN ROR VS. INVEST LEVEL

# Set invest levels and standard deviation of RORs
invest_levels <- seq(0, 1, by = 0.01)
mean_rors <- sapply(
    invest_levels,
    function(x) mean(gen_rors(num_ror = 100, invest_level = x))
)

# Plot the mean RORs against the invest levels
png("/Users/cavendish/Desktop/不同投资水平的ROR均值曲线.png")
plot(
    invest_levels,
    mean_rors,
    type = "l",
    xlab = "Invest Level",
    ylab = "Mean ROR",
    main = "Mean ROR vs. Invest Level"
)
dev.off()

# Plot the log of mean RORs against the invest levels
png("/Users/cavendish/Desktop/不同投资水平的ROR均值曲线_log.png")
plot(
    invest_levels,
    log(mean_rors),
    type = "l",
    xlab = "Invest Level",
    ylab = "Log Mean ROR",
    main = "Log Mean ROR vs. Invest Level"
)
dev.off()



# CURVE OF STANDARD DEVIATION VS. INVEST LEVEL

# Set invest levels and standard deviation of RORs
invest_levels <- seq(0, 1, by = 0.01)
sd_rors <- sapply(
    invest_levels,
    function(x) sd(gen_rors(num_ror = 100, invest_level = x))
)

# Plot the standard deviation of RORs against the invest levels
png("/Users/cavendish/Desktop/不同投资水平的ROR标准差曲线.png")
plot(
    invest_levels,
    sd_rors,
    type = "l",
    xlab = "Invest Level",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Invest Level"
)
dev.off()



# BOXPLOT OF ROR WITH DIFFERENT FREQUENCIES

# Set the max number, invest_freq and invest_level
num_ror <- 1000
invest_level <- 0.56

# Simulate RORs with different frequencies, and plot the boxplot diagram
png("/Users/cavendish/Desktop/不同频率的ROR箱线图.png")
boxplot(
    gen_rors(day_return, num_ror, invest_level, 0,),
    gen_rors(day_return, num_ror, invest_level, 0.25),
    gen_rors(day_return, num_ror, invest_level, 0.5),
    gen_rors(day_return, num_ror, invest_level, 0.75),
    gen_rors(day_return, num_ror, invest_level, 1),
    main = "Boxplot of ROR with different frequencies",
    xlab = "Frequency",
    ylab = "ROR",
    names = c("0", "0.25", "0.5", "0.75", "1")
    )
# Add a y = 1.5346 line
abline(h = 1.5346, col = "red")
# Add a legend of num_ror, invest level and the line
legend(
    "topleft",
    legend = c(
        paste("Numbers:", num_ror),
        paste("Invest level:", invest_level),
        paste("Hold for 10 years ROR = 1.5346")
    ),
    col = c("black", "black", "red"),
    lty = c(1, 1, 1), cex = 0.8
)
dev.off()



# CURVE OF STANDARD DEVIATION VS. INVEST FREQUENCY

# Set investment frequencies and standard deviations of RORs
invest_freqs <- seq(0, 1, by = 0.01)
sd_rors <- sapply(
    invest_freqs,
    function(x) sd(gen_rors(num_ror = 100, invest_freq = x))
)

# Plot the standard deviation of RORs against the invest frequencies
png("/Users/cavendish/Desktop/不同投资频率的ROR标准差曲线.png")
plot(
    invest_freqs,
    sd_rors,
    type = "l",
    xlab = "Invest Frequency",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Invest Frequency"
)
dev.off()



# 错过涨幅最大的几天

# Calculate ROR for a given number of missed days
calculate_ror <- function(missed_days, day_return) {
  ordered_day_return <- day_return[order(day_return, decreasing = TRUE)]
  prod(ordered_day_return[(missed_days + 1):length(ordered_day_return)])
}

# Define missed days
missed_days <- c(0, 5, 10, 20, 25, 30, 40, 50)

# Calculate ROR for each missed day
ror <- sapply(missed_days, calculate_ror, day_return = day_return)

# Print ROR values
cat(paste("ROR for missed", missed_days, "days:", ror, "\n"))

# Plot the bar chart with x-axis labels
png("/Users/cavendish/Desktop/错过涨幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = missed_days
)
dev.off()

# Plot the line diagram
png("/Users/cavendish/Desktop/错过涨幅最大的几天折线图.png")
plot(
  missed_days,
  ror,
  type = "l",
  xlab = "Missed Days",
  ylab = "ROR",
  main = "Relationship between ROR and Missed Days"
)
dev.off()



# 避开跌幅最大的几天

# Calculate ROR for a given number of missed days
calculate_ror <- function(missed_days, day_return) {
  ordered_day_return <- day_return[order(day_return, decreasing = FALSE)]
  prod(ordered_day_return[(missed_days + 1):length(ordered_day_return)])
}

# Define missed days
missed_days <- c(0, 5, 10, 20, 25, 30, 40, 50)

# Calculate ROR for each missed day
ror <- sapply(missed_days, calculate_ror, day_return = day_return)

# Print ROR values
cat(paste("ROR for missed", missed_days, "days:", ror, "\n"))

# Plot the bar chart with x-axis labels
png("/Users/cavendish/Desktop/避开跌幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = missed_days
)
dev.off()

# Plot the line diagram
png("/Users/cavendish/Desktop/避开跌幅最大的几天折线图.png")
plot(
  missed_days,
  ror,
  type = "l",
  xlab = "Missed Days",
  ylab = "ROR",
  main = "Relationship between ROR and Missed Days"
)
dev.off()



# 避开跌幅最大的几天条形图

# Define x-axis labels
x_labels <- paste("Missed", missed_days, "Days", sep = " ")

# Plot the bar chart with x-axis labels
png("/Users/cavendish/Desktop/避开跌幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = x_labels
)
dev.off()



# BOXPLOT OF ROR FOR DIFFERENT HOLDING PERIODS

# Set coordinates
holds <- c(1, 5, 22, 63, 250, 500, 2430)
xy <- lapply(holds, function(x) gen_rors(hold = x))
xy <- setNames(xy, holds)

# Plot boxplot of RORs for different holding periods
png("/Users/cavendish/Desktop/不同持有期的ROR箱线图.png")
boxplot(
    xy,
    main = "ROR Boxplot for Different Hold Periods",
    xlab = "Hold Period",
    ylab = "ROR"
)
dev.off()



# CURVE OF MEAN ROR VS. HOLDING PERIOD

# Generate holds and mean of RORs
holds <- seq(1, 2430, by = 10)
mean_rors <- sapply(
    holds,
    function(hold) mean(gen_rors(num_ror = 100, hold = hold))
)

# Plot the mean of RORs against the holding period
png("/Users/cavendish/Desktop/不同持有期的ROR均值曲线.png")
plot(
    holds,
    mean_rors,
    type = "l",
    xlab = "Hold Period",
    ylab = "Mean ROR",
    main = "Mean ROR vs. Hold Period"
)
dev.off()



# CURVE OF STANDARD DEVIATION VS. HOLD PERIOD

# Set holds and standard deviation of RORs
holds <- seq(1, 2430, by = 10)
sd_rors <- sapply(
    holds,
    function(hold) sd(gen_rors(num_ror = 100, hold = hold))
)

# Plot the standard deviation of RORs against the invest frequencies
png("/Users/cavendish/Desktop/不同持有期的ROR标准差曲线.png")
plot(
    holds,
    sd_rors,
    type = "l",
    xlab = "Hold Period",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Hold Period"
)
dev.off()



# DENSITY OF ROR

# Prepare data
num_ror <- 1000
invest_level <- 0.5
invest_freq <- 1
hold <- 1
rors <- gen_rors(
    num_ror = num_ror,
    invest_level = invest_level,
    invest_freq = invest_freq,
    hold = hold
)
mean_rors <- round(mean(rors), 4)
xy <- density(rors)

# Plot the density curve
png("/Users/cavendish/Desktop/ROR的概率密度图.png")
plot(xy, main = "Density of ROR", xlab = "ROR")

# Add x = 1 line
abline(v = 1, col = "red")

# Add legend
legend(
    "topright",
    legend = c(
        paste("numbers:", num_ror),
        paste("invest level:", invest_level),
        paste("invest freqency:", invest_freq),
        paste("hold:", hold),
        paste("mean:", mean_rors)
    )
)

# Close the graphics device
dev.off()

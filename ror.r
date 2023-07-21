# Import libraries
library(graphics)

# Import data from csv file
data_index <- read.csv("~/Desktop/data_index.csv")[, 3] + 1
data_mao <- read.csv("~/Desktop/data_mao.csv")[, 3] + 1
data_meng <- read.csv("~/Desktop/data_meng.csv")[, 3] + 1

# Select data to use
day_return <- data_index

# Define function to generate ROR for a given investment strategy
rors <- function(day_return, num_ror = 1, invest_level = 0.5, invest_freq = 1, hold = 1, trans_cost = 0.001) { # nolint: line_length_linter.
    # Initialize RORs
    rors <- numeric(0)

    # Calculate the number of holding periods
    num_period <- length(day_return) %/% hold

    # Calculate the period returns
    period_returns <- numeric(num_period)
    for (i in 1:num_period) {
    start_index <- (i - 1) * hold + 1
    end_index <- i * hold
    period_returns[i] <- prod(day_return[start_index:end_index])
    }
    if(length(day_return) %% hold != 0) {
    period_returns <- c(period_returns, prod(day_return[(num_period * hold + 1):length(day_return)])) # nolint: line_length_linter.
    }

    # Get the rightful invest strategy
    right_invest <- period_returns > 1

    for (i in 1:num_ror) {
        # Generate number of considers
        num_consid <- round(invest_freq * length(period_returns))

        # Generate consider vector
        consider <- sample(
            c(rep(TRUE, num_consid), rep(FALSE, length(period_returns) - num_consid)), # nolint: line_length_linter.
            length(period_returns),
            replace = FALSE
        )

        # Generate invest vector
        invest <- sample(
            c(TRUE, FALSE),
            length(period_returns),
            replace = TRUE,
            prob = c(invest_level, 1 - invest_level)
        )
        invest <- invest == right_invest

        ror <- prod(period_returns[consider & invest])

        # Consider transaction cost
        ror <- (1 - trans_cost) ** length(period_returns[consider & invest]) * ror # nolint: line_length_linter.


        # Calculate RORs using vectorized operations
        rors <- c(rors, ror)
    }

    # Return RORs
    return(rors)
}
# Plot the density diagram of ROR

# Set the max number, invest_freq and invest_level
num_ror <- 10000
invest_level <- 0.5
invest_freq <- 1

# Simulate RORs to plot density diagram
rors <- rors(day_return, num_ror, invest_level, invest_freq)

# Create a new png to plot the density diagram
png("~/Desktop/ROR的概率密度图.png")
plot(density(rors), main = "Density of ROR", xlab = "ROR")

# Add x = 1 line
abline(v = 1, col = "red")

# Add a legend of num_ror, invest freqency, invest level, the line, the mean and standard deviation
legend(
    "topright",
    legend = c(
        paste("Numbers:", num_ror),
        paste("invest level:", invest_level),
        paste("invest freqency:", invest_freq),
        paste("mean:", round(mean(rors), 4)),
        paste("standard deviation:", round(sd(rors), 4))
    )
)

# Close the graphics device
dev.off()
# Plot the boxplot diagram of ROR with different invest levels

# Set the max number, invest_freq and invest_level
num_ror <- 1000
invest_freq <- 1

# Simulate RORs with different invest levels, and plot the boxplot diagram
png("~/Desktop/不同投资水平的ROR箱线图.png")
boxplot(
    rors(day_return, num_ror, 0.475, invest_freq),
    rors(day_return, num_ror, 0.5, invest_freq),
    rors(day_return, num_ror, 0.525, invest_freq),
    rors(day_return, num_ror, 0.55, invest_freq),
    rors(day_return, num_ror, 0.56, invest_freq),
    rors(day_return, num_ror, 0.575, invest_freq),
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
# Plot the boxplot diagram of ROR with different frequencies

# Set the max number, invest_freq and invest_level
num_ror <- 1000
invest_level <- 0.56

# Simulate RORs with different frequencies, and plot the boxplot diagram
png("~/Desktop/不同频率的ROR箱线图.png")
boxplot(
    rors(day_return, num_ror, invest_level, 0,),
    rors(day_return, num_ror, invest_level, 0.25),
    rors(day_return, num_ror, invest_level, 0.5),
    rors(day_return, num_ror, invest_level, 0.75),
    rors(day_return, num_ror, invest_level, 1),
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
png("~/Desktop/错过涨幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = missed_days
)
dev.off()

# Plot the line diagram
png("~/Desktop/错过涨幅最大的几天折线图.png")
plot(
  missed_days,
  ror,
  type = "l",
  xlab = "Missed Days",
  ylab = "ROR",
  main = "Relationship between ROR and Missed Days"
)
dev.off()
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
png("~/Desktop/避开跌幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = missed_days
)
dev.off()

# Plot the line diagram
png("~/Desktop/避开跌幅最大的几天折线图.png")
plot(
  missed_days,
  ror,
  type = "l",
  xlab = "Missed Days",
  ylab = "ROR",
  main = "Relationship between ROR and Missed Days"
)
dev.off()
# Define x-axis labels
x_labels <- paste("Missed", missed_days, "Days", sep = " ")



# Plot the bar chart with x-axis labels
png("~/Desktop/避开跌幅最大的几天条形图.png")
barplot(
  ror,
  main = "Relationship between ROR and Missed Days",
  xlab = "Missed Days",
  names.arg = x_labels
)
dev.off()
# Plot function curve of Mean ROR vs. Invest Level

# Generate a set of RORs for different invest levels
invest_levels <- seq(0, 1, by = 0.01)
mean_rors <- numeric(length(invest_levels))
for (i in seq_along(invest_levels)) {
    rors_i <- rors(day_return, 100, invest_levels[i], 1)
    mean_rors[i] <- mean(rors_i)
}

# Plot the mean RORs against the invest levels
png("~/Desktop/不同投资水平的ROR均值曲线.png")
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
png("~/Desktop/不同投资水平的ROR均值曲线_log.png")
plot(
    invest_levels,
    log(mean_rors),
    type = "l",
    xlab = "Invest Level",
    ylab = "Log Mean ROR",
    main = "Log Mean ROR vs. Invest Level"
)
dev.off()
# Plot the curve of Standard Deviation of ROR vs. Invest Level

# Generate a set of RORs for different invest levels
invest_levels <- seq(0, 1, by = 0.01)
sd_rors <- numeric(length(invest_levels))
for (i in seq_along(invest_levels)) {
    rors_i <- rors(day_return, 100, invest_levels[i], 1)
    sd_rors[i] <- sd(rors_i)
}

# Plot the standard deviation of RORs against the invest levels
png("~/Desktop/不同投资水平的ROR标准差曲线.png")
plot(
    invest_levels,
    sd_rors,
    type = "l",
    xlab = "Invest Level",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Invest Level"
)
dev.off()

# Plot the curve of Standard Deviation of ROR vs. Invest Frequency

# Generate a set of RORs for different invest frequencies
invest_freqs <- seq(0, 1, by = 0.01)
sd_rors <- numeric(length(invest_freqs))
for (i in seq_along(invest_freqs)) {
    rors_i <- rors(day_return, 100, 0.5, invest_freqs[i])
    sd_rors[i] <- sd(rors_i)
}

# Plot the standard deviation of RORs against the invest frequencies
png("~/Desktop/不同投资频率的ROR标准差曲线.png")
plot(
    invest_freqs,
    sd_rors,
    type = "l",
    xlab = "Invest Frequency",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Invest Frequency"
)
dev.off()

# Define hold periods
hold_periods <- c(1, 5, 22, 63, 250, 2430)

# Calculate RORs for each hold period using a loop
num_ror <- 1000
rors_matrix <- matrix(nrow = num_ror, ncol = length(hold_periods))

for (i in seq_along(hold_periods)) {
    rors_matrix[, i] <- rors(day_return, num_ror = num_ror, hold = hold_periods[i])
}
colnames(rors_matrix) <- hold_periods

# Plot boxplot of RORs for each hold period
png("~/Desktop/不同持有期的ROR箱线图.png")
boxplot(rors_matrix, main = "ROR Boxplot for Different Hold Periods", xlab = "Hold Period", ylab = "ROR")
dev.off()

# Plot the curve of Standard Deviation of ROR vs. Hold Period

# Generate a set of RORs for different hold periods
holds <- seq(1, 2430, by = 10)
sd_rors <- numeric(length(holds))
for (i in seq_along(holds)) {
    rors_i <- rors(day_return, 1000, 0.5, hold = holds[i])
    sd_rors[i] <- sd(rors_i)
}

# Plot the standard deviation of RORs against the invest frequencies
png("~/Desktop/不同持有期的ROR标准差曲线.png")
plot(
    holds,
    sd_rors,
    type = "l",
    xlab = "Hold Period",
    ylab = "Standard Deviation of ROR",
    main = "Standard Deviation of ROR vs. Hold Period"
)
dev.off()

# Plot the curve of Mean ROR vs. Hold Period

# Generate a set of RORs for different hold periods
holds <- seq(1, 2430, by = 10)
mean_rors <- numeric(length(holds))
for (i in seq_along(holds)) {
    rors_i <- rors(day_return, 1000, 0.5, hold = holds[i])
    mean_rors[i] <- mean(rors_i)
}

# Plot the standard deviation of RORs against the invest frequencies
png("~/Desktop/不同持有期的ROR均值曲线.png")
plot(
    holds,
    mean_rors,
    type = "l",
    xlab = "Hold Period",
    ylab = "Mean ROR",
    main = "Mean ROR vs. Hold Period"
)
dev.off()

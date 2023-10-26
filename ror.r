library(graphics)

# Define function to generate ROR for a given investment strategy
gen_RORs <- function(day_returns, num_ror = 100, invest_level = 0.5, invest_freq = 1, hold = 1, trans_cost = 0.001) {
    # Period returns
    period_returns <- apply(matrix(c(day_returns, rep(1, times = -length(day_returns) %% hold)), nrow = hold), MARGIN = 2, FUN = prod)
    # RORs
    replicate(num_ror, {
        # Focusing periods
        focusing_periods <- sample(c(TRUE, FALSE), size = length(period_returns), replace = TRUE, prob = c(invest_freq, 1 - invest_freq))
        # Investment choices
        if_invest <- sample(c(TRUE, FALSE), size = length(period_returns), replace = TRUE, prob = c(invest_level, 1 - invest_level)) == (period_returns > 1)
        # ROR
        prod(period_returns[focusing_periods & if_invest] * (1 - trans_cost))
    })
}

# ROR line chart with error bars
line_with_error_bar <- function(data_name, k_sd = 0.12, x = seq(0.4, 0.6, length.out = 20), var = "Invest Level", FUN = function(x) gen_RORs(invest_level = x, day_returns = day_return_data)) {
    mean_RORs <- sapply(x, function(x) mean(FUN(x)))
    sd_RORs <- sapply(x, function(x) sd(FUN(x)))
    y_lower <- mean_RORs - k_sd * sd_RORs
    y_upper <- mean_RORs + k_sd * sd_RORs
    # Plot line chart
    png(paste0("./rplots/", data_name, "/Mean ROR vs ", var, ".png"))
    plot(x = x, y = mean_RORs, type = "l", main = paste0("Mean ROR vs ", var), xlab = var, ylab = "Mean ROR")
    sapply(seq_along(x), function(i) segments(x0 = x[i], y0 = y_lower[i], y1 = y_upper[i], lwd = 2))
    dev.off()
}

# Define function to generate plots
main_plot <- function(data_name = "index") {
    # Import data from csv file
    day_return_data <- read.csv(paste0("./data/data_", data_name, ".csv"))[, 3] + 1
    # Plot line chart with error bars
    line_with_error_bar(data_name, x = seq(0.4, 0.6, length.out = 20), var = "Invest Level", FUN = function(x) gen_RORs(invest_level = x, day_returns = day_return_data))
    line_with_error_bar(data_name, x = seq(0, 1, length.out = 20), var = "Invest Freqency", FUN = function(x) gen_RORs(invest_freq = x, day_returns = day_return_data))
    line_with_error_bar(data_name, x = seq(1, length(day_return_data), length.out = 20), var = "Hold Period", FUN = function(x) gen_RORs(hold = x, day_returns = day_return_data))
}

main_plot("index")
main_plot("maotai")
main_plot("mengjie")

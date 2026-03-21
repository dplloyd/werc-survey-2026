# Plot theming
# 

# Define your palette
palette <- c(
  dark_blue   = "#00008B",
  medium_blue = "#0000CD",
  pink        = "#FFC0CB"
)


# Custom theme
theme_werc <- function(base_size = 12) {
  afcharts::theme_af(base_size = base_size)
    
}

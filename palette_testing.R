library(ggplot2)
library(scales)  # for gradient functions

# West Edinburgh Running Club custom palette
werc_palette <- c(
  "pink"       = "#FF3E96",  # Logo pink
  "dark_blue"  = "#0B0E3F",  # Logo dark blue
  "light_pink" = "#FF99C1",  # Lighter accent
  "medium_blue"= "#1A1F66",  # Medium blue accent
  "gray"       = "#F2F2F2",  # Neutral light gray
  "dark_gray"  = "#333333"   # Neutral dark gray for text
)

# Example discrete color usage in ggplot
ggplot(mtcars, aes(x = factor(cyl), y = mpg, fill = factor(cyl))) +
  geom_col() +
  scale_fill_manual(values = c(
    werc_palette[["pink"]],
    werc_palette[["medium_blue"]],
    werc_palette[["dark_blue"]]
  )) +
  theme_minimal() +
  theme(
    text = element_text(color = werc_palette["dark_blue"]),
    panel.background = element_rect(fill = werc_palette["dark_gray"]),
    plot.background  = element_rect(fill = werc_palette["gray"])
  )

# Example continuous gradient (heatmaps, line plots)
gradient_colors <- c(werc_palette["pink"], werc_palette["medium_blue"], werc_palette["dark_blue"])

ggplot(mtcars, aes(x = wt, y = mpg, color = mpg)) +
  geom_point(size = 4) +
  scale_color_gradientn(colors = gradient_colors) +
  theme_minimal() +
  theme(
    text = element_text(color = werc_palette["dark_blue"])
  )


monochromeR::generate_palette(
  "#FF3E96",
  n_colours = 3,
  view_palette = TRUE,
  view_labels = FALSE,
  modification = "go_both_ways",
)


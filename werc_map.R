# =============================================================================
# Script Name:    werc_map.R
# Author:         Diarmuid Lloyd
# Date Created:   02-Mar-2026
# Last Updated:   02-Mar-2026
# Version:        1.0
# R Version:      4.3.1
# Purpose:        Construct map of training distance preferences
# 
# Notes:          
# =============================================================================


library(sf)
library(maptiles)
library(ggmap)

werc_palette_3 <- monochromeR::generate_palette("#FF3E96", blend_colour = "#1A1F66", 
                                                n_colours = 3, view_palette = FALSE, view_labels = FALSE)
bbox_saughton <- c(
  left   = -3.310516,
  bottom = 55.917056,
  right  = -3.184345,
  top    = 55.952921
)
zoom <- 14

werc_location <- tibble(location = "WERC", lat = 55.9356845, lon = -3.2478984)

distance_data <- tibble(
  radius_km  = c(0.8, 1.6, 3.2, 5),
  proportion = c(0.96, 0.86, 0.54,0.32)
)



get_stadiamap(bbox_saughton, zoom = 14, maptype = "stamen_terrain_lines") |> 
  ggmap() +
  geom_point(data = werc_location, aes(x = lon, y = lat ), colour = werc_palette_3[1]) +
  theme_minimal()


# Convert to sf (WGS84)
werc_sf <- st_as_sf(
  werc_location,
  coords = c("lon", "lat"),
  crs = 4326
)

#  Transform to a projected CRS (Edinburgh → British National Grid). Use EPSG:27700.
werc_proj <- st_transform(werc_sf, 27700)

# Create a buffer
circle_5km <- st_buffer(werc_proj, dist = 1000)
# Transform back to WGS84 for plotting with ggmap
circle_5km_wgs84 <- st_transform(circle_5km, 4326)


# Plot the map
get_stadiamap(bbox_saughton, zoom = 14, maptype = "stamen_terrain_lines") |>
  ggmap() +
  geom_sf(data = circle_5km_wgs84,
          inherit.aes = FALSE,
          fill = NA,
          colour = werc_palette_3[2],
          linewidth = 1) +
  geom_sf(data = werc_sf,
          inherit.aes = FALSE,
          colour = werc_palette_3[1],
          size = 3) +
  theme_minimal()


distance_data$dist_m <- distance_data$radius_km * 1000

circles <- map_dfr(distance_data$radius_km, ~
                     st_buffer(werc_proj, .x * 1000),
                   .id = "radius_id"
) |>
  st_as_sf() |>
  st_transform(4326) |> 
  mutate(distance_km = distance_data$radius_km, proportion = distance_data$proportion)

# Plot the map
get_stadiamap(bbox_saughton, zoom = 15, maptype = "stamen_terrain_lines") |>
  ggmap() +
  geom_sf(data = circles,
          inherit.aes = FALSE,
          fill = NA,
          colour = werc_palette_3[2],
          linewidth = 1) +
  geom_sf(data = werc_sf,
          inherit.aes = FALSE,
          colour = werc_palette_3[1],
          size = 1) +
  theme_minimal()


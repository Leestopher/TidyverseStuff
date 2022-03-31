#install.packages("tidyverse")
#install.packages("jsonlite")
#install.packages("ggthemes")
#install.packages("scales")
#install.packages("ggplot2")
#install.packages("leaflet")
#install.packages("dplyr")

library(dplyr)
library(tidyverse)
library(sf)
library(jsonlite)
library(leaflet)
library(tibbletime)
library(ggthemes)
library(scales)
library(ggplot2)

studio_album_tracks <- readr::read_csv("https://github.com/jacquietran/spice_girls_data/raw/main/data/studio_album_tracks.csv")

glimpse(studio_album_tracks)

studio_album_tracks$artist_name

studio_album_tracks %>%
  group_by(key_mode) %>%
  summarise(
    danceability_mean = mean(danceability),
    energy_mean = mean(energy),
    valence_mean = mean(valence),
    mean_mean = ((danceability_mean + energy_mean + valence_mean) / 3)
    )

studio_album_tracks %>%
    count(key_mode,
    sort = TRUE,
    name = "songs")

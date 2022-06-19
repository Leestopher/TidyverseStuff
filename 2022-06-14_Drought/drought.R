library(dplyr)
library(tidyverse)
library(sf)
library(jsonlite)
library(leaflet)
library(tibbletime)
library(ggthemes)
library(scales)
library(ggplot2)
library(tidytuesdayR)
library(httpgd)

httpgd::hgd()
httpgd::hgd_browse()

tuesdata <- tidytuesdayR::tt_load('2022-06-14')

drought <- tuesdata$drought
drought_fips <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-06-14/drought-fips.csv')

drought
view(drought)

drought_ga <- drought_fips %>% group_by(date) %>% summarise(
    DSCI = mean(DSCI), State = State) %>% filter(
    State == "GA"
)

drought_plot <- ggplot(drought_ga, aes(x = date, y = DSCI)) +
    geom_line(color = "black")

drought_plot

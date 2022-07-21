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
drought_fips <- tuesdata$`drought-fips`

drought_ga <- drought_fips %>% filter(
    State == "GA") %>% group_by(date) %>% summarise(
    DSCI = mean(DSCI), State = State)

drought_plot <- ggplot(drought_ga, aes(x = date, y = DSCI)) +
    geom_line(color = "black")

drought_plot

#could use drought.csv to "count" wet days and dry days by year, to see if there is a trend

ga_fips <- drought_fips %>% filter (State =="GA") %>% group_by(
    date, FIPS) %>% summarise(DSCI = mean(DSCI))

ga_fips

# install.packages("tidytuesdayR")
install.packages("httpgd")

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
library(leaflet)

httpgd::hgd()
httpgd::hgd_browse()

tuesdata <- tidytuesdayR::tt_load('2022-03-29')

sports <- tuesdata$sports

sports

gasports <- sports %>% 
    filter(state_cd == "GA" & sports == "Bowling" & total_rev_menwomen > 0)

gasportsplot <- ggplot(gasports, aes(x = institution_name, y = total_rev_menwomen)) +
    geom_boxplot()

gasportsplot

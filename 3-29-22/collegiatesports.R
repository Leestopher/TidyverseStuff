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

bball <- sports %>%
    select(sum_partic_men, sum_partic_women, rev_men, rev_women, state_cd, year, sports) %>%
    filter(year == 2015 & rev_men > 0 & rev_women > 0 & sports == 'Basketball') %>%
    group_by(state_cd) 

bballperstudent <- bball %>%
    summarise(
        dollarpermale = sum(rev_men / sum_partic_men),
        dollarperfemale = sum(rev_women / sum_partic_women))

anotherbadplot <- ggplot(bballperstudent, aes(x = dollarpermale, y = dollarperfemale, label = state_cd)) +
    geom_text()

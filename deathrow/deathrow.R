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
library(lubridate)
library(httpgd)
library(tidytext)

#install.packages("tidytext")

httpgd::hgd()
httpgd::hgd_browse()

deathrow <- read_csv("https://raw.githubusercontent.com/firstlookmedia/the-condemned-data/master/the-condemed-data.csv")

glimpse(deathrow)

deathrow <- deathrow %>% mutate(
    Status = recode(Status, 'Not Currently On Death Row' = 'Not Currently on Death Row'))

#Less than expected number of executions
deathrow %>% count(
        Status) %>% mutate(Status = fct_reorder(Status, n)) %>%
ggplot(aes(Status, n)) +
geom_col() +
coord_flip()

#What about % by race?
deathrow %>%
    count(race, Status) %>%
    group_by(race) %>%
    mutate(freq = n / sum(n)) %>%
    ungroup() %>%
    mutate(Status = reorder_within(Status, freq, race)) %>%
    ggplot(aes(x = Status, freq, fill = race)) +
    geom_col() +
    coord_flip() +
    scale_x_reordered() +
    facet_wrap(race ~., scales = "free")

#Highest % executed by race is white, then Hispanic followed closely by black    

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

tuesdata <- tidytuesdayR::tt_load('2022-05-31')

poll <- tuesdata$poll
reputation <- tuesdata$reputation

#boxplots of rank by industry?
poll %>% group_by(company) %>%
ggplot(aes(x = industry, y = `2022_rank`)) +
geom_boxplot() +
theme(axis.text.x = element_text(angle = 90))

reputation %>% group_by(company) %>%
ggplot(aes(x = industry, y = rank)) +
geom_boxplot() +
theme(axis.text.x = element_text(angle = 90))

poll %>% group_by(industry) %>%
summarise(mean = mean(`2022_rank`),
         median = median(`2022_rank`)) %>%
         arrange(desc(median))

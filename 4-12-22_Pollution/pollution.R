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
library(httpgd)



httpgd::hgd()
httpgd::hgd_browse()

tuesdata <- tidytuesdayR::tt_load('2022-04-12')

in_poll <- tuesdata$indoor_pollution

contpoll <- in_poll %>%
    filter(is.na(Code))

countrypoll <- in_poll %>%
    filter(Code != "")

contpoll

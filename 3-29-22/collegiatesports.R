install.packages("tidytuesdayR")

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

tuesdata <- tidytuesdayR::tt_load('2022-03-29')

sports <- tuesdata$sports

sports

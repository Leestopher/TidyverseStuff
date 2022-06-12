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

tuesdata <- tidytuesdayR::tt_load('2022-06-07')

donations <- tuesdata$pride_aggregates
static <- tuesdata$static_list

join_data <- donations %>%
  inner_join(static, by = "Company")

#Obviously, the more politicians, the more donations.
join_data %>% ggplot(aes(x = `# of Politicians Contributed to.x`, y = `Total Contributed`, label = Company, color = `HRC Business Pledge`)) +
geom_point() +
geom_jitter(width = 0.5, height = 0.5) +
scale_x_log10() +
scale_y_log10()


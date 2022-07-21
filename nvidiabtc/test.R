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

httpgd::hgd()
httpgd::hgd_browse()

install.packages("lubridate")
install.packages("fuzzyjoin")


bitcoin <- read_csv('nvidiabtc/data/bitcoin10.csv')
nvidia <- read_csv('nvidiabtc/data/NVidia_stock_history.csv')
sp500 <- read_csv('nvidiabtc/data/SPX.csv')

# both sets have Jan 1 2011 to Jan 1 2020

bitcoin2011 <- bitcoin %>% mutate(Date = as_date(Date, format = "%b %d, %Y")) %>% filter(Date >= '2011-01-01')

nvidia2011 <- nvidia %>% filter(Date >= '2011-01-01')

sp500 <- sp500 %>% filter(Date >= '2011-01-01')

join <- inner_join(bitcoin2011, nvidia2011, by = c("Date" = "Date"), suffix = c("bitcoin", "nvidia"))

join <- inner_join(join, sp500, by = c("Date" = "Date"))

join

join %>% ggplot(aes(Date)) +
geom_line(aes(y = Openbitcoin, colour = "red")) +
geom_line(aes(y = (Opennvidia), colour = "black")) +
geom_line(aes(y = Open, colour = "blue")) +
scale_y_log10()

sp500
join

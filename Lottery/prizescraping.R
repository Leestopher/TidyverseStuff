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
library(rvest)
library(jsonlite)
library(janitor)

#install.packages("janitor")
#install.packages("jsonlite")

nm_active <- read_html("https://www.nmlottery.com/games/scratchers/")

active_games <- nm_active %>% 
    html_nodes("h3") %>%
    html_text()

game_codes <- nm_active %>%
    html_nodes("p.game-number") %>%
    html_text()

game_price <- nm_active %>%
    html_nodes("p.price") %>%
    html_text()

game_tables <- nm_active %>% 
    html_nodes("table.data") %>%
    html_table()

game_tables %>% as.character()

game_tables %>% make_clean_names()

compare_df_cols(game_tables, return = "mismatch")

bind_rows(modify_depth(game_tables, 2, as.factor))

game_tables

data.frame(
    active_games = active_games,
    game_codes = game_codes,
    game_price = game_price
)

map_dfr(game_tables,
    ~.x %>%
    html_nodes("td") %>% mutate(across(everything(), as.double) %>%
    as_tibble))

game_tables

length(active_games)

#for 1-length(active_games), html_nodes("table.data") %>% html_table %>% pluck(i) tbl[[i]]$i <- i, i <- i + 1
#In words, this says to go through each table on the site, 1-the current number of active games, and then extract the table.  
#Give them each a new index, starting at 1, then put them all together in one data frame.
tbl <- list()
i <- 1
for (i in 1:length(active_games)) {
    tbl[[i]] <- nm_active %>%
    html_nodes("table.data") %>%
    html_table() %>%
    pluck(i)
    tbl[[i]]$i <- i
    i <- i + 1
}

tbl <- do.call(rbind, tbl)

tbl

#Really can't believe this worked.
#So, first things first, clean column names.

#Next, join with active_games, game_codes, and game_price.

#Now, change data type of columns to numeric, and also fix PRIZE TICKET

#Now, we should be able to calculate Expected Value for each active game.


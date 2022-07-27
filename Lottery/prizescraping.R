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

tbl <- tbl %>% rename(Prize = "Prize: th >", Odds = "Approx. Odds 1 in: th >",
Total_Prizes = "Approx. # of Prizes: th >",
Remaining_Prizes = "Approx. Prizes Remaining:", Game_Num = i)

tbl$Game_Num = as.num

#Next, join with active_games, game_codes, and game_price.

active_games <- active_games %>% as_tibble() %>% rowid_to_column("Game_Num")

game_codes <- game_codes %>% as_tibble() %>% rowid_to_column("Game_Num")

game_codes$value <- gsub('[Game Number: ]', '', game_codes$value)

game_codes <- game_codes %>% rename(Game_Code = "value")

game_price <- game_price %>% as_tibble() %>% rowid_to_column("Game_Num")

join1 <- inner_join(active_games, tbl, by = "Game_Num") %>%
    inner_join(game_codes, by = "Game_Num") %>%
    inner_join(game_price, by = "Game_Num") %>%
    rename(Game_Name = "value.x", Price = "value.y")

#Now, change data type of columns to numeric, and also fix PRIZE TICKET

#Now, we should be able to calculate Expected Value for each active game.
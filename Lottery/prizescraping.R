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

#for 1-length(active_games), html_nodes("table.data")
#%>% html_table %>% pluck(i) tbl[[i]]$i <- i, i <- i + 1
#In words, this says to go through each table on the site,
#1-the current number of active games, and then extract the table.
#Give them each a new index, starting at 1,
#then put them all together in one data frame.

tbl <- list()

i <- 1

for (i in seq_along(active_games)) {
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

#Next, join with active_games, game_codes, and game_price.

active_games <- active_games %>% as_tibble() %>% rowid_to_column("Game_Num")

game_codes <- game_codes %>% as_tibble() %>% rowid_to_column("Game_Num")

game_codes$value <- gsub("[Game Number: ]", "", game_codes$value)

game_codes <- game_codes %>% rename(Game_Code = "value")

game_price <- game_price %>% as_tibble() %>% rowid_to_column("Game_Num")

join1 <- inner_join(active_games, tbl, by = "Game_Num") %>%
    inner_join(game_codes, by = "Game_Num") %>%
    inner_join(game_price, by = "Game_Num") %>%
    rename(Game_Name = "value.x", Price = "value.y")

#Fix Prize Ticket in Prize column.
join1$Prize <- with(join1, ifelse(Prize == "PRIZE TICKET", "$0", Prize))
join1$Prize <- with(join1, ifelse(Prize == "Prize Ticket", "$0", Prize))
join1$Prize <- with(join1, ifelse(Prize == "Ticket", "$0", Prize))



#chr to numeric
join1

join1$Prize <- gsub("\\$", "", join1$Prize)
join1$Prize <- gsub(",", "", join1$Prize)
join1$Odds <- gsub(",", "", join1$Odds)
join1$Total_Prizes <- gsub(",", "", join1$Total_Prizes)
join1$Remaining_Prizes <- gsub(",", "", join1$Remaining_Prizes)
join1$Price <- gsub("\\$", "", join1$Price)

options(digits = 10)
join1$Odds <- as.numeric(join1$Odds)
join1$Price <- as.numeric(join1$Price)
join1$Total_Prizes <- as.numeric(join1$Total_Prizes)
join1$Remaining_Prizes <- as.numeric(join1$Remaining_Prizes)
join1$Prize <- as.numeric(join1$Prize)

#Now, we should be able to calculate Expected Value for each active game.
ev <- join1 %>% group_by(Game_Name) %>%
    mutate(Total_Tickets = (max(Total_Prizes) * min(Odds)),
    Tickets_Rem = (max(Remaining_Prizes) * min(Odds)),
    Current_Odds = (Remaining_Prizes / Tickets_Rem),
    Lose_Odds = ((1-sum(Current_Odds)) * Price * (-1)))

ev %>% filter(Prize > 0) %>%
    summarise(Expected_Value = (sum(Current_Odds * Prize)) + Lose_Odds) %>%
    slice(which.max(Expected_Value)) %>%
    arrange(desc(Expected_Value))

ev

ev %>% group_by(Game_name)

ev %>% filter(Prize <1) %>%
    mutate(Tickets_minusfree = Tickets_Rem - Remaining_Prizes)

# working with census data

setwd("C:/Users/15079/Desktop/School/Data Analysis in R")

#install.packages(c("tidycensus", "tidyverse", "plotly"))
library(tidycensus)

#install.packages(c("dplyr", "tibble"))
library(dplyr)
library(tibble)

#get data using api

census_api_key("716a043724c078b3d862cacd09ff079a765ea82b", install = TRUE, overwrite=TRUE)
readRenviron("~/.Renviron")#idk my error message told me to do this

#searching for variables.  NOTE there are MANY.

# EBR example
# get demographics and total population data for LA
# at the census tract level from us census/ acs
# need to restrict to east baton rouge parish (county code = 033)
# may want to rename variables E = estimate, M = margin of error

EBR_wide <- get_acs(
  geography = "tract",
  state = "LA",
  county = "033",
  variables = c(total_pop = "B01003_001",
                white = "B02001_002",
                black = "B02001_003",
                american_indian = "B02001_004",
                asian = "B02001_005",
                native_hawaiian = "B02001_006",
                other = "B02001_007",
                two_or_more = "B02001_008"),
  output = "wide")
View(EBR_wide)
order(EBR_wide)
colnames(EBR_wide)
EBR <-EBR_wide[order(EBR_wide$GEOID),] 
EBR<-EBR[-92,,]

# load other datasets from GitHub

ejscreen <- read.csv ("https://raw.githubusercontent.com/jirvin6/DAR/main/ejscreen_2022.csv")
cdc_places <- read.csv ("https://raw.githubusercontent.com/jirvin6/DAR/main/CDC_Places.csv")

# OK. Now we need to combine this data
data_frame <-cbind(EBR,ejscreen,cdc_places) #this should do the trick if the column matches 
View(data_frame)

#calculate percent black (from ACS data) and add to dataframe

data_frame$percent_black <- (data_frame$blackE /data_frame$total_popE)*100
data_frame$percent_black = round(data_frame$percent_black, digits = 2)

#make some simple scatter plots

library(tidyverse)
ggplot(data = data_frame,
       mapping = aes(x = percent_black, y = LifeExp)) +
  geom_point()

ggplot(data = data_frame,
       mapping = aes(x = percent_black, y = rmp)) +
  geom_point()




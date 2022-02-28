# working with census data

setwd("C:/Users/15079/Desktop/School/Data Analysis in R")

install.packages(c("tidycensus", "tidyverse", "plotly"))
library(tidycensus)

#get data using api

census_api_key("716a043724c078b3d862cacd09ff079a765ea82b", install = TRUE)
readRenviron("~/.Renviron")#idk my error message told me to do this

#searching for variables.  NOTE there are MANY.

vars <- load_variables(2019, "acs5")
View(vars)

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

# load other datasets from GitHub

ejscreen <- read.csv ("https://raw.githubusercontent.com/jirvin6/DAR/main/ejscreen_2022.csv")
cdc_places <- read.csv ("https://raw.githubusercontent.com/jirvin6/DAR/main/CDC_Places.csv")
ebr_wide <- read.csv ("https://raw.githubusercontent.com/jirvin6/DAR/main/ebr_wide.csv")
View(ebr_wide)

# OK. Now we need to combine this data
EBR<-EBR[-92,,]
data_frame <-cbind(EBR,ejscreen,cdc_places) #this should do the trick if the column matches 
View(data_frame)


#Graph_01
ggplot(data = data_frame, mapping = aes(x= traffic, y=OBESITY_CrudePrev))+
  geom_point(mapping = aes(color = education))+
  geom_smooth()

#Graph_02
ggplot(data = data_frame) + 
  geom_point(mapping = aes(x = blackM, y=hazardous_waste)) +
  facet_wrap(~ ozone, nrow = 2)

#Graph_03
boxplot(data_frame$blackM ~ data_frame$hazardous_waste,
        xlab = "BlackM", # x-axis label
        ylab = "Hazardous_Waste", # y-axis label
        las = 1, # Rotate numbers on y-axis
        ylim = c(0,1000), # Range of y-axis
        col = "lightblue", # Boxplot fill color
        border = "darkred", # Boxplot border color
        pch = 19) # Symbol for outliers

### Manipulating Site Occupancy into unmarked format

library(tidyverse)
library(unmarked)

 ## uploading the data , We are using the file Dane sent titled 
 ## "dummy RADR OCC lab meeting 10_30.xlsx" I only resaved it as a csv file

radr.occ <- read.csv("./Data/RADR_OCC.csv" )

obs.df <- read.csv("./Data/Obser_level.csv")

site.df <- read.csv("./Data/Site_level.csv" )


## adding in site level variables 


colnames(site.df) <- c("SiteCode","Elev", "Forest" )


## Selecting the only rows we are currently interested in ( probably dont need
## "site.year" )

radr.y <- select( radr.occ, c( "site", "site.year", "site.year.round", 
                               "RADR_ADULT_TOTAL"))

radr.y <- filter(radr.y, SiteCode %in% site.df$SiteCode)


colnames(radr.y) <- c("SiteCode", "SiteYear", "SiteYearRound", "RADR")

## Need to remove "Site" from "SiteYearRound"

radr.y <- separate(radr.y, SiteYearRound, sep=-6 , c("ThrowAway", "YearRound"))

## Now lets get rid of the redundant new SiteCode column called "ThrowAway"

radr.y1 <- select( radr.y, c("SiteCode", "YearRound", "RADR")) 

## Cool lets reshape it to get it in the proper format

radr.y2 <- reshape(radr.y1, idvar = "SiteCode", 
                   timevar = "YearRound", direction = "wide")

## lets rearrange the columns so they are in chronological order

radr.y2 <- select( radr.y2, c("SiteCode", "RADR.1997_1","RADR.1997_2", 
                              "RADR.1998_1", "RADR.1998_2", "RADR.1999_1",
                              "RADR.1999_2","RADR.2005_1", "RADR.2006_1",
                              "RADR.2007_1","RADR.2007_2","RADR.2008_1",
                              "RADR.2008_2", "RADR.2009_1","RADR.2009_2",
                              "RADR.2010_1","RADR.2010_2", "RADR.2011_1",
                              "RADR.2011_2","RADR.2012_1", "RADR.2012_2",
                              "RADR.2013_1", "RADR.2013_2", "RADR.2014_1",
                              "RADR.2014_2","RADR.2015_1","RADR.2015_2",
                              "RADR.2016_1","RADR.2016_2","RADR.2017_1",
                              "RADR.2017_2","RADR.2018_1","RADR.2018_2") )

colnames(radr.y2) <- c("SiteCode", "1997_1","1997_2", 
                       "1998_1", "1998_2", "1999_1",
                       "1999_2","2005_1", "2006_1",
                       "2007_1","2007_2","2008_1",
                       "2008_2", "2009_1","2009_2",
                       "2010_1","2010_2", "2011_1",
                       "2011_2","2012_1", "2012_2",
                       "2013_1", "2013_2", "2014_1",
                       "2014_2","2015_1","2015_2",
                       "2016_1","2016_2","2017_1",
                       "2017_2","2018_1","2018_2") 


colSums(radr.y2[,2:33], na.rm=T)


## Filtering for the proper site codes

radr.y2 <- filter(radr.y2, SiteCode %in% site.df$SiteCode)



#write.csv( radr.y2, file = "RADR_OCC.csv")



## ok lets fix the observation data


## obs.df <- read.csv("./Data/Obser_level.csv")

obs.df$AssmtCode <- obs.df$site.year.round 

## need to separate a column to get the desired columns
##  WYNNE I KNOW THIS IS SUPER MESSY BUT DON'T JUDGE ME

obs.df1 <- separate(obs.df, site.year.round, sep=-7 , c("SiteCode", "YearRound"))

obs.df1 <- separate(obs.df1, YearRound, sep=-1 , c("Year", "Round"))

obs.df1 <- separate(obs.df1, Year, sep=-1 , c("Year", "throw"))

obs.df1 <- separate(obs.df1, Year, sep=1 , c("Throw", "Year"))

## filtering to maintain uniform site codes

obs.df1<- filter(obs.df1, SiteCode %in% site.df$SiteCode)


obser.df <- select( obs.df1,c("SiteCode", "Year", "Round","PondArea..m.",
                              "Perimeter..m.", "Temp..","DRY" ) )

## renaming varables

colnames(obser.df)[4:7] <- c( "Area", "Perimeter", "Temp", "Dry") 

# Whoops forgor I need "Year" and "Round" as a single varible

obser.df <- unite( obser.df, "YearRound", c("Year", "Round"), sep= "_" )

### According to unmarked we need to have each observation variable in its own
### data frame so lets do that

### creating a df for observation level Area

obArea.df <- obser.df[,c(1,2,3)]

obArea.df <- reshape(obArea.df, idvar = "SiteCode", 
                   timevar = "YearRound", direction = "wide")

## lets rearrange the columns so they are in chronological order

obArea.df <- select( obArea.df, c("SiteCode", "Area.1997_1","Area.1997_2", 
                              "Area.1998_1", "Area.1998_2", "Area.1999_1",
                              "Area.1999_2","Area.2005_1", "Area.2006_1",
                              "Area.2007_1","Area.2007_2","Area.2008_1",
                              "Area.2008_2", "Area.2009_1","Area.2009_2",
                              "Area.2010_1","Area.2010_2", "Area.2011_1",
                              "Area.2011_2","Area.2012_1", "Area.2012_2",
                              "Area.2013_1", "Area.2013_2", "Area.2014_1",
                              "Area.2014_2","Area.2015_1","Area.2015_2",
                              "Area.2016_1","Area.2016_2","Area.2017_1",
                              "Area.2017_2","Area.2018_1","Area.2018_2") )

## Lets rename the column names so they are consistent

colnames(obArea.df) <-  c("SiteCode", "1997_1","1997_2", 
                                  "1998_1", "1998_2", "1999_1",
                                  "1999_2","2005_1", "2006_1",
                                  "2007_1","2007_2","2008_1",
                                  "2008_2", "2009_1","2009_2",
                                  "2010_1","2010_2", "2011_1",
                                  "2011_2","2012_1", "2012_2",
                                  "2013_1", "2013_2", "2014_1",
                                  "2014_2","2015_1","2015_2",
                                  "2016_1","2016_2","2017_1",
                                  "2017_2","2018_1","2018_2") 

### creating a df for observation level Perimeter

obPerim.df <- obser.df[,c(1,2,4)]

obPerim.df <- reshape(obPerim.df, idvar = "SiteCode", 
                     timevar = "YearRound", direction = "wide")

## Cheonological order!

obPerim.df <- select( obPerim.df, c("SiteCode", "Perimeter.1997_1","Perimeter.1997_2", 
                                  "Perimeter.1998_1", "Perimeter.1998_2", "Perimeter.1999_1",
                                  "Perimeter.1999_2","Perimeter.2005_1", "Perimeter.2006_1",
                                  "Perimeter.2007_1","Perimeter.2007_2","Perimeter.2008_1",
                                  "Perimeter.2008_2", "Perimeter.2009_1","Perimeter.2009_2",
                                  "Perimeter.2010_1","Perimeter.2010_2", "Perimeter.2011_1",
                                  "Perimeter.2011_2","Perimeter.2012_1", "Perimeter.2012_2",
                                  "Perimeter.2013_1", "Perimeter.2013_2", "Perimeter.2014_1",
                                  "Perimeter.2014_2","Perimeter.2015_1","Perimeter.2015_2",
                                  "Perimeter.2016_1","Perimeter.2016_2","Perimeter.2017_1",
                                  "Perimeter.2017_2","Perimeter.2018_1","Perimeter.2018_2") )


## Consistency !!!!!!


colnames(obPerim.df) <-  c("SiteCode", "1997_1","1997_2", 
                          "1998_1", "1998_2", "1999_1",
                          "1999_2","2005_1", "2006_1",
                          "2007_1","2007_2","2008_1",
                          "2008_2", "2009_1","2009_2",
                          "2010_1","2010_2", "2011_1",
                          "2011_2","2012_1", "2012_2",
                          "2013_1", "2013_2", "2014_1",
                          "2014_2","2015_1","2015_2",
                          "2016_1","2016_2","2017_1",
                          "2017_2","2018_1","2018_2") 


### creating a df for observation level for Temp.

obTemp.df <- obser.df[,c(1,2,5)]

obTemp.df  <- reshape(obTemp.df, idvar = "SiteCode", 
                      timevar = "YearRound", direction = "wide")

## Chronological Order

obTemp.df <- select( obTemp.df, c("SiteCode", "Temp.1997_1","Temp.1997_2", 
                                    "Temp.1998_1", "Temp.1998_2", "Temp.1999_1",
                                    "Temp.1999_2","Temp.2005_1", "Temp.2006_1",
                                    "Temp.2007_1","Temp.2007_2","Temp.2008_1",
                                    "Temp.2008_2", "Temp.2009_1","Temp.2009_2",
                                    "Temp.2010_1","Temp.2010_2", "Temp.2011_1",
                                    "Temp.2011_2","Temp.2012_1", "Temp.2012_2",
                                    "Temp.2013_1", "Temp.2013_2", "Temp.2014_1",
                                    "Temp.2014_2","Temp.2015_1","Temp.2015_2",
                                    "Temp.2016_1","Temp.2016_2","Temp.2017_1",
                                    "Temp.2017_2","Temp.2018_1","Temp.2018_2") )

## Consistency !!!!!!

colnames(obTemp.df) <-  c("SiteCode", "1997_1","1997_2", 
                          "1998_1", "1998_2", "1999_1",
                          "1999_2","2005_1", "2006_1",
                          "2007_1","2007_2","2008_1",
                          "2008_2", "2009_1","2009_2",
                          "2010_1","2010_2", "2011_1",
                          "2011_2","2012_1", "2012_2",
                          "2013_1", "2013_2", "2014_1",
                          "2014_2","2015_1","2015_2",
                          "2016_1","2016_2","2017_1",
                          "2017_2","2018_1","2018_2") 


### creating a df for observation level dry

obDry.df <- obser.df[,c(1,2,6)]

obDry.df  <- reshape(obDry.df, idvar = "SiteCode", 
                      timevar = "YearRound", direction = "wide")

# Chronological Order
 
obDry.df <- select( obDry.df, c("SiteCode", "Dry.1997_1","Dry.1997_2", 
                                  "Dry.1998_1", "Dry.1998_2", "Dry.1999_1",
                                  "Dry.1999_2","Dry.2005_1", "Dry.2006_1",
                                  "Dry.2007_1","Dry.2007_2","Dry.2008_1",
                                  "Dry.2008_2", "Dry.2009_1","Dry.2009_2",
                                  "Dry.2010_1","Dry.2010_2", "Dry.2011_1",
                                  "Dry.2011_2","Dry.2012_1", "Dry.2012_2",
                                  "Dry.2013_1", "Dry.2013_2", "Dry.2014_1",
                                  "Dry.2014_2","Dry.2015_1","Dry.2015_2",
                                  "Dry.2016_1","Dry.2016_2","Dry.2017_1",
                                  "Dry.2017_2","Dry.2018_1","Dry.2018_2") )

# Consistency!

colnames(obDry.df) <-  c("SiteCode", "1997_1","1997_2", 
                          "1998_1", "1998_2", "1999_1",
                          "1999_2","2005_1", "2006_1",
                          "2007_1","2007_2","2008_1",
                          "2008_2", "2009_1","2009_2",
                          "2010_1","2010_2", "2011_1",
                          "2011_2","2012_1", "2012_2",
                          "2013_1", "2013_2", "2014_1",
                          "2014_2","2015_1","2015_2",
                          "2016_1","2016_2","2017_1",
                          "2017_2","2018_1","2018_2") 


## Ok lets now compile them into a single list because why not

radr.obs <- list( SiteCode= obTemp.df[,1], Area = obArea.df[,2:33],
                  Perim = obPerim.df[,2:33], 
             Temp = obTemp.df[,2:33], Dry= obDry.df[,2:33])



## Checking to make sure the diminsions are all good

dim(radr.y2) ## 387 x 33

dim(site.df) ## 387 x 3

dim(obArea.df) ## 387 x 33

dim(obPerim.df) ## 387 x 33

dim(obTemp.df) ## 387 x 33

dim(obDry.df) ## 387 x 33


# Cool all the data is filtered and have the same site code now we can begin to
# model
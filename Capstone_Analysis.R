
#STEP 1. Obtaining Data

#Import Human Freedom Index (HFI) and Suicide rates indexes.
library(readxl)
human_freedom_index_2022 <- read_excel("Downloads/human-freedom-index-2022.xlsx")
SUICIDES_1_ <- read_excel("Downloads/SUICIDES (1).xlsx")

#STEP 2. Cleaning Datasets

#HFI DATA:

library(dplyr)
#Create a new dataset (FD) from HFI dataset that only selects relevant variables
freedom_divorce = subset(human_freedom_index_2022, select = c( Country, Year, `HUMAN FREEDOM QUARTILE`, `Gii Divorce`))

#Update FD so that it only includes observations from 2010 and later. 
freedom_divorce_2 = freedom_divorce%>%
  filter(Year >= 2010)

#Rename dataset for simplicity. 
DIVORCE = freedom_divorce_2


#SUICIDE DATA: 

#Rename dataset for convenience. 
SUICIDE = SUICIDES_1_

#Rename column 'Year' in SUICIDE to allow for simpler merging later on. 
SUICIDE$Year = SUICIDE$TIME

#In order to merge the two datasets, the countries in SUICIDE must be renamed 
#from their standard abbreviations to their full names (Example: AUS = Australia). 


#Create a translation set for future reference. 
country_conversion <- c(
  "AUS" = "Australia",
  "AUT" = "Austria",
  "BEL" = "Belgium",
  "CAN" = "Canada",
  "CZE" = "Czech Republic",
  "DNK" = "Denmark",
  "FIN" = "Finland",
  "FRA" = "France",
  "DEU" = "Germany",
  "GRC" = "Greece",
  "HUN" = "Hungary",
  "ISL" = "Iceland",
  "ITA" = "Italy",
  "JPN" = "Japan",
  "KOR" = "Korea",
  "LUX" = "Luxembourg",
  "MEX" = "Mexico",
  "NLD" = "Netherlands",
  "NZL" = "New Zealand",
  "NOR" = "Norway",
  "POL" = "Poland",
  "PRT" = "Portugal",
  "SVK" = "Slovak Republic",
  "ESP" = "Spain",
  "SWE" = "Sweden",
  "CHE" = "Switzerland",
  "GBR" = "United Kingdom",
  "USA" = "United States",
  "BRA" = "Brazil",
  "CHL" = "Chile",
  "EST" = "Estonia",
  "ISR" = "Israel",
  "RUS" = "Russia",
  "SVN" = "Slovenia",
  "ZAF" = "South Africa",
  "TUR" = "Turkey",
  "COL" = "Colombia",
  "LVA" = "Latvia",
  "LTU" = "Lithuania",
  "CRI" = "Costa Rica",
  "ARG" = "Argentina",
  "BGR" = "Bulgaria",
  "HRV" = "Croatia",
  "IRN" = "Iran",
  "ROU" = "Romania"
)

#Rename column "LOCATION" to to "Country" for future merging. 
colnames(SUICIDE)[1] = 'Country' 

#Convert "Country" column to character type. 
SUICIDE$Country <- as.character(SUICIDE$Country)

#Convert abbreviations to full names using translation set.
SUICIDE$Country <- country_conversion[SUICIDE$Country]

#Select only relevant variables. 
SUICIDE = subset(SUICIDE, select = c(Year, Country, Value))

#Find which countries are contained in this dataset by isolating individual
#occurences 
suicide_countries <- unique(SUICIDE$Country)

#Merging datasets

#Create a new divorce dataset that only includes the countries identified
#in the previous step. 
filtered_DIVORCE <- subset(DIVORCE, Country %in% suicide_countries)

#finally, merge the two datasets (DIVORCE and SUICIDE) by corresponding years and
#countries 
merged_data <- merge(DIVORCE, SUICIDE, by = c("Year", "Country"))
colnames(merged_data) <- c("Year", "Country", "Human Freedom Quartile", "Divorce_freedom","Suicides_per_100k")

#Step 3. Exploration and Preliminary Analysis. 

#SUMMARY STATS
library(ggplot2)

#Calculate the counts for each quartile.
quartile_counts <- table(merged_data$`Human Freedom Quartile`)

#Create a boxplot of suicides for each quartile
ggplot(merged_data, aes(x = factor(`Human Freedom Quartile`), y = Suicides_per_100k, fill = factor(`Human Freedom Quartile`))) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  xlab("Human Freedom Quartile") +
  ylab("Suicides per 100k") +
  ggtitle("Distribution of Suicides per 100k by Human Freedom Quartile") +
  theme_minimal() 


#Note: The boxplots show a general trend, but the presence of outliers
#seem likely. To investigate further, each quartile should be independantly 
#investigated. 

#Create subsets of the main dataset for each quartile
quartile1 <- merged_data[merged_data$`Human Freedom Quartile` == 1, ]
quartile2 <- merged_data[merged_data$`Human Freedom Quartile` == 2, ]
quartile3 <- merged_data[merged_data$`Human Freedom Quartile` == 3, ]
quartile4 <- merged_data[merged_data$`Human Freedom Quartile` == 4, ]

#Create separate plots for each quartile
plot_q1 <- ggplot(quartile1, aes(x = Divorce_freedom, y = Suicides_per_100k)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  xlab("Divorce Freedom") +
  ylab("Suicides per 100k") +
  ggtitle("Quartile 1")

plot_q2 <- ggplot(quartile2, aes(x = Divorce_freedom, y = Suicides_per_100k)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  xlab("Divorce Freedom") +
  ylab("Suicides per 100k") +
  ggtitle("Quartile 2")

plot_q3 <- ggplot(quartile3, aes(x = Divorce_freedom, y = Suicides_per_100k)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  xlab("Divorce Freedom") +
  ylab("Suicides per 100k") +
  ggtitle("Quartile 3")

plot_q4 <- ggplot(quartile4, aes(x = Divorce_freedom, y = Suicides_per_100k)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  xlab("Divorce Freedom") +
  ylab("Suicides per 100k") +
  ggtitle("Quartile 4")

#Create a single grid showing all of the plots. 
library(gridExtra)
grid.arrange(plot_q1, plot_q2, plot_q3, plot_q4, nrow = 2, ncol = 2)

#Based on these plots, the initial instinct would be to use only quartile 2
#and possible quartile 1. The other two, and possible quartile 1 as well 
#do not show a consistent pattern, high variability, or too few observations. 

#Step 4. Data Analysis 

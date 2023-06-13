
#STEP 1. Obtaining Data

#Import Human Freedom Index (HFI) and Suicide rates indexes.
library(readxl)
human_freedom_index_2022 <- read_excel("Downloads/HFINDEX.xlsx")
SUICIDES_1_ <- read_excel("Downloads/SUICIDES.xlsx")
Divorce_Rates <- read_excel("Downloads/DIVORCE_RATE.xlsx")

#STEP 2. Cleaning Datasets

#HFI DATA:

library(dplyr)
#Create a new dataset (FD) from HFI dataset that only selects relevant variables
freedom_divorce = subset(human_freedom_index_2022, select = c( Country, Year, `HUMAN FREEDOM QUARTILE`, `Gii Divorce`))

#Update FD so that it only includes observations between 2010 and 2017 
freedom_divorce_2 = freedom_divorce%>%
  filter(Year >= 2010 & Year <= 2017)

#Rename dataset for simplicity. 
DIVORCE = freedom_divorce_2


#SUICIDE DATA: 


#Rename dataset for convenience. 
SUICIDE = SUICIDES_1_

#Set Year range to match FD range.
SUICIDE = SUICIDE%>%
  filter(Year >= 2010 & Year <= 2017)

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

#DIVORCE_RATE DATASET:

#Set Year range to match other two dataset ranges.
Divorce_Rates = Divorce_Rates%>%
  filter(Year >= 2010 & Year <= 2018)

#Rename 'entity' to 'Country.'
colnames(Divorce_Rates)[1] = 'Country' 

#Rename last column to 'Divorces_per_1k'
colnames(Divorce_Rates)[4] = 'Divorces_per_1k'

#Select only relevant variables
Divorce_Rates = subset(Divorce_Rates, select = -c(Code))

#Merging datasets

#Create a new divorce dataset that only includes the countries identified
#in the previous step. 
filtered_DIVORCE <- subset(DIVORCE, Country %in% suicide_countries)
Divorce_rates_filtered <- subset(Divorce_Rates, Country %in% suicide_countries)


#finally, merge the two datasets (filtered_DIVORCE and SUICIDE) by corresponding years and
#countries 
merged_data <- merge(filtered_DIVORCE, SUICIDE, by = c("Year", "Country"))
colnames(merged_data) <- c("Year", "Country", "Human Freedom Quartile", "Divorce_freedom","Suicides_per_100k")

merged_data <- merge(merged_data, Divorce_rates_filtered, by = c("Year", "Country"))

#Step 3. Exploration and Preliminary Analysis. 

#SUMMARY STATS
library(ggplot2)

#Calculate the counts for each quartile.
quartile_counts <- table(merged_data$`Human Freedom Quartile`)

#scatterplot of freedom score against suicide rates
ggplot(merged_data, aes(x = Divorce_freedom, y = Suicides_per_100k )) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Divorce Freedom", y = "Suicides per 100K") +
  ggtitle("Scatter Plot of Divorce Freedom Scores and Suicide Rates") 


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


#Step 4. Data Analysis 

#To produce more accurate results, testing between divorce freedom and 
#suicide rates will be done using a single year and restricted to 
#quartiles 1-3 to meet sample size requirements. 

SecondQuartile = merged_data%>%
  filter(`Human Freedom Quartile` == 1   & Year == 2017)
SecondQuartile <- merged_data %>%
  filter(`Human Freedom Quartile` %in% c(1, 2, 3) & Year == 2017)



#an ANOVA test will be used to determine any differences in suicide rates
#between divorce freedom ranks. 

model1 = aov(Suicides_per_100k ~ as.factor(Divorce_freedom), data = SecondQuartile)
anova_result = summary(model1)

#The resulting p-value of 0.0519 indicates the differences are quite nearly significant.
 
#However, the results of the post hoc test show only one differnece is significant
#and one of the compared groups only had two observations. The lack of observations
#combined with the insignificance of the other two comparisons leaves us without 
#enough evidence to conclude there are any significant differences. Thus, it can 
#be currently concluded that divorce freedom and suicide are not significantly correlated. 

posthoc_result <- TukeyHSD(model1)


#Now, looking at the relationship between divorce freedom and Divorce rates,
#There appears to be no correlation. 

ggplot(SecondQuartile, aes(x = Divorce_freedom, y = Divorces_per_1k )) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Divorce Freedom", y = "Divorces per 100k") +
  ggtitle("Scatter Plot of Divorces per 1k and Divorce Freedom Score") 

#As expected, running an ANOVA test on this model again proved insignificant.

model2 = aov(Divorces_per_1k ~ as.factor(Divorce_freedom), data = SecondQuartile)
summary(model2)



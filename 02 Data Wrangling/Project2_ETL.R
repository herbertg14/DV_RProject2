require("ggplot2")
require("ggthemes")
require("gplots")
require("grid")
require("RCurl")
require("reshape2")
require("rstudio")
require("tableplot")
require("tidyr")
require("dplyr")
require("jsonlite")
require("extrafont")
require("lubridate")



setwd("~/DataVisualization/DV_RProject2/02 Data Wrangling")

file_path <- "./01\ Data/LeadingCausesStateYear.csv"

"""
df <- read.csv(file_path, stringsAsFactors = FALSE)

str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("YEAR","DEATHS","AADR")

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:

dimensions <- setdiff(names(df), measures)

sql <- paste("CREATE TABLE", "COD", "(\n")
if( length(dimensions) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
"""



# Import Data from SQL database
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from COD"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary(df)
head(df)

#Data Wrangling
#Collection without confidence interval

df %>% select(CAUSE_NAME,STATE,AADR,YEAR) %>% filter(STATE == "Texas", (CAUSE_NAME == "Diabetes" | CAUSE_NAME == "Diseases of Heart"| CAUSE_NAME == "Alzheimers disease"| CAUSE_NAME == "Stroke"| CAUSE_NAME == "Chronic liver disease and cirrhosis"| CAUSE_NAME == "Cancer")) %>% ggplot(aes(x = YEAR, y = AADR, color = CAUSE_NAME)) + geom_point() + labs(title='Texas Leading COD 1999-2013') + labs(x="Year", y="Age-Adjusted Death Rate per 100,000 people") +geom_line()
  
df %>% select(STATE,YEAR,CAUSE_NAME,AADR) %>% filter(STATE == "United States" | STATE == "Texas" |STATE == "District of Columbia" |STATE == "Colorado" |STATE == "Louisiana",CAUSE_NAME == "All Causes") %>% ggplot(aes(x=YEAR,y = AADR, color = STATE)) + geom_point() + geom_line() + labs(title='Time Series Change in Death Rate by State 1999 - 2013') + labs(x="Year", y="Age-Adjusted Death Rate per 100,000 People")

df %>% select(STATE,AADR,YEAR,CAUSE_NAME) %>% filter(CAUSE_NAME == "Suicide",YEAR=="2013") %>%  ggplot(aes(x=reorder(STATE,AADR),y=AADR, fill=STATE)) + geom_bar(stat = "identity") + coord_flip() + theme(legend.position="none") + labs(x = "State",y = "Age-Adjusted Death Ratio per 100,000 People",title = "Suicide Rates by State in 2013")



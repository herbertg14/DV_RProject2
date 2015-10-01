require(tidyr)
require(dplyr)
require(ggplot2)

setwd("/Users/Ryan_Wechter/DataVisualization/DV_RProject2")

file_path <- "./01\ Data/LEADINGCAUSESOFDEATH.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

dimensions <- c("CHSI_State_Name","CHSI_State_Abbr", "CHSI_County_Name")

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:

measures <- setdiff(names(df), dimensions)

sql <- paste("CREATE TABLE", "COD", "(\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
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



# Import Data from SQL database
df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from COD"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary(df)
head(df)

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

#Data Wrangling
#Collection without confidence interval
dfWOci <- c()
for (d in measures) {
    if(grepl("CI",d) == FALSE) {
      dfWOci <- c(dfWOci,d)
    }
}

#Collection under age 1
Young <- c()
for (d in dfWOci) {
  if(grepl("A_",d) == TRUE) {
    Young <- c(Young,d)
  }
}

#Collection from age 1-14
Adolescent <- c()
for (d in dfWOci) {
  if(grepl("B_",d) == TRUE) {
    Adolescent <- c(Adolescent,d)
  }
}

#Collection for ages 15-24
Teen <- c()
for (d in dfWOci) {
  if(grepl("C_",d) == TRUE) {
    Teen <- c(Teen,d)
  }
}

#Collection for ages 25-44
Adult <- c()
for (d in dfWOci) {
  if(grepl("D_",d) == TRUE) {
    Adult <- c(Adult,d)
  }
}

#Collection for ages 45-64
Mature <- c()
for (d in dfWOci) {
  if(grepl("E_",d) == TRUE) {
    Mature <- c(Mature,d)
  }
}

#Collection for ages 65+
Old <- c()
for (d in dfWOci) {
  if(grepl("F_",d) == TRUE) {
    Old <- c(Old,d)
  }
}

#Collection for White
White <- c()
for (d in dfWOci) {
  if(grepl("Wh",d) == TRUE) {
    White <- c(White,d)
  }
}

#Collection for Black
Black <- c()
for (d in dfWOci) {
  if(grepl("Bl_",d) == TRUE) {
    Black <- c(Black,d)
  }
}

#Collection for Hispanic
Hispanic <- c()
for (d in dfWOci) {
  if(grepl("Hi",d) == TRUE) {
    Hispanic <- c(Hispanic,d)
  }
}

#Collection for Whitewalkers
Other <- c()
for (d in dfWOci) {
  if(grepl("Ot",d) == TRUE) {
    Other <- c(Other,d)
  }
}

#Collection for Birth Complications
Comp <- c()
for (d in dfWOci) {
  if(grepl("Comp",d) == TRUE) {
    Comp <- c(Comp,d)
  }
}

#Collection for Birth Defects
Def <- c()
for (d in dfWOci) {
  if(grepl("Def",d) == TRUE) {
    Def <- c(Def,d)
  }
}

#Collection for Injury
Injury <- c()
for (d in dfWOci) {
  if(grepl("Injury",d) == TRUE) {
    Injury <- c(Injury,d)
  }
}

#Collection for Cancer
Cancer <- c()
for (d in dfWOci) {
  if(grepl("Cancer",d) == TRUE) {
    Cancer <- c(Cancer,d)
  }
}

#Collection for Homicide
Homicide <- c()
for (d in dfWOci) {
  if(grepl("omic",d) == TRUE) {
    Homicide <- c(Homicide,d)
  }
}

#Collection for Suicide
Suicide <- c()
for (d in dfWOci) {
  if(grepl("Suicide",d) == TRUE) {
    Suicide <- c(Suicide,d)
  }
}
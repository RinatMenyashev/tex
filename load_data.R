library('quantmod')
library(data.table)
library(ggplot2)
library(Thinknum)

getSymbols("AAPL")

chartSeries(AAPL, subset='last 3 months')
addBBands()


##===========Before downloading the file, pls ensure that only UTF-8 characters are their. It's Ё it my initial file==========
##===========faster remove by hand================================================

trans <- data.table(read.csv(file = "texata-list-acquisitions.csv", stringsAsFactors = FALSE))

str(trans)

trans[, datestr := gsub(Date.of.Transaction.Completion..Estimated., pattern = "Aprilil|Aprril", rep = "April")]
trans[, datestr := gsub(datestr, pattern = "Octpber", rep = "October")]
trans[, datestr := gsub(datestr, pattern = "Septembert", rep = "September")]
trans[ datestr == "Q1 Fiscal2010", datestr := 'March 1, 2010']
trans[ datestr == "Late 2014", datestr := 'December 1, 2014']

trans[ datestr == 'August 2005, 2010', datestr := "June 30, 2010"]  # according to Wikipedia
trans[, Date.of.Transaction.Completion..Estimated. := NULL]
trans

trans[, date := ifelse(is.na(as.Date(datestr,format = " %B %d,%Y")), as.Date(datestr,format = " %B %d %Y"), as.Date(datestr,format = " %B %d,%Y"))]
trans[, date := as.Date(date)]


##==========Check what we have ============================
trans[is.na(date)]

trans[, list(min(date), max(date))]

trans[, .N, by = year(date)][order(N, decreasing = T)]
trans[, .N, by = month(date)]
trans[, .N, by = Acquiror][order(N, decreasing = T)]


##=================in R, we have packages for everything=======
##===============Add more merger data from external sources ==== 
#install.packages("qmao", repos="http://R-Forge.R-project.org")
library(qmao)

getMergersCalendar(from = Sys.Date()-500, to = Sys.Date())

##=========We are done with Y variable, how we need to construct our Xs=========



##=========2 hours messing with AWS Data=================================

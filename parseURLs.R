#Create the data frame from a file containing the urls to parse
data <- read.table("URLs_To_Parse.txt")
data$urls <- as.character(data$V1)
# Know the length of the file that contains the urls to parse
totalLen <- nrow(data)

# Get the info from all urls and bind the information together
library(XML)
library(dplyr)
totalTable <- data.frame()

#for(i in 1:totalLen) {
#  rowInfo <- as.character(data[i,1])
#  table <- readHTMLTable(row)
#  totalTable <- dplyr::bind_rows(totalTable, table)
#}

for(url in data$urls) {
  table <- readHTMLTable(url)
  totalTable <- dplyr::bind_rows(totalTable,table)
}
names(totalTable)[1] <- "ID_1"
names(totalTable)[2] <- "Date_1"
names(totalTable)[3] <- "Author_1"
names(totalTable)[4] <- "Target_1"
names(totalTable)[5] <- "Description_1"
names(totalTable)[6] <- "Attack_1"
names(totalTable)[7] <- "Target_Class_1"
names(totalTable)[8] <- "Category_1"
names(totalTable)[9] <- "Country_1"
names(totalTable)[10] <- "Link_1"
names(totalTable)[11] <- "Category_2"
names(totalTable)[12] <- "Tags"
names(totalTable)[13] <- "ID_2"
names(totalTable)[14] <- "Description_2"
names(totalTable)[15] <- "ID_3"
names(totalTable)[16] <- "Date_2"
names(totalTable)[17] <- "Author_2"
names(totalTable)[18] <- "Target_2"
names(totalTable)[19] <- "Description_3"
names(totalTable)[20] <- "Attack_2"
names(totalTable)[21] <- "Target_Class_2"
names(totalTable)[22] <- "Category_3"
names(totalTable)[23] <- "Country_2"
names(totalTable)[24] <- "ID_4"
names(totalTable)[25] <- "Target_Class_3"
names(totalTable)[26] <- "Category_4"

#Unify all the IDs
totalTable <- dplyr::mutate(totalTable, ID = ifelse(test=is.na(ID_1), yes = ifelse(test = is.na(ID_2), yes = ifelse(test = is.na(ID_3), yes = ID_4, no = ID_3), no = ID_2),no = ID_1))
#Unify all Dates
totalTable <- dplyr::mutate(totalTable, Date = ifelse(test = is.na(Date_1), yes = Date_2, no = Date_1))
#Unify all Authors
totalTable <- dplyr::mutate(totalTable, Author = ifelse(test = is.na(Author_1), yes = Author_2, no = Author_1))
#Unify all Targets
totalTable <- dplyr::mutate(totalTable, Target = ifelse(test = is.na(Target_1), yes = Target_2, no = Target_1))
#Unify all Descriptions
totalTable <- dplyr::mutate(totalTable, Description = ifelse(test = is.na(Description_1), yes = ifelse(test = is.na(Description_2), yes = Description_3, no = Description_2), no = Description_1))
#Unify all Attacks
totalTable <- dplyr::mutate(totalTable, Attack = ifelse(test = is.na(Attack_1), yes = Attack_2, no = Attack_1))
#Unify all Target Classes
totalTable <- dplyr::mutate(totalTable, Target_Class = ifelse(test = is.na(Target_Class_1), yes = ifelse(test = is.na(Target_Class_2), yes = Target_Class_3, no = Target_Class_2), no = Target_Class_1))
#Unify all Categories
totalTable <- dplyr::mutate(totalTable, Category = ifelse(test = is.na(Category_1), yes = ifelse(test = is.na(Category_2), yes = ifelse(test = is.na(Category_3), yes = Category_4, no = Category_3), no = Category_2),no = as.character(Category_1)))
#Unify Countries
totalTable <- dplyr::mutate(totalTable, Country = ifelse(test = is.na(Country_1), yes = Country_2, no = Country_1))
#We don't care about information link
#We delete all the columns we dont want
totalTable$ID_1 <- NULL
totalTable$Date_1 <- NULL
totalTable$Author_1 <- NULL
totalTable$Target_1 <- NULL
totalTable$Description_1 <- NULL
totalTable$Attack_1 <- NULL
totalTable$Target_Class_1 <- NULL
totalTable$Category_1 <- NULL
totalTable$Country_1 <- NULL
totalTable$Link_1 <- NULL
totalTable$Category_2 <- NULL
totalTable$Tags <- NULL
totalTable$ID_2 <- NULL
totalTable$Description_2 <- NULL
totalTable$ID_3 <- NULL
totalTable$Date_2 <- NULL
totalTable$Author_2 <- NULL
totalTable$Target_2 <- NULL
totalTable$Description_3 <- NULL
totalTable$Attack_2 <- NULL
totalTable$Target_Class_2 <- NULL
totalTable$Category_3 <- NULL
totalTable$Country_2 <- NULL
totalTable$ID_4 <- NULL
totalTable$Target_Class_3 <- NULL
totalTable$Category_4 <- NULL

#solve the dates

# transformDates <- function(x){
#   aux <- unlist(strsplit("May 16"," ", fixed=TRUE))
#   strTime <- paste(aux[2],aux[1],"2015", sep="")
#   x<-format(strptime(strTime, "%d%b%Y"), "%d/%m/%Y")
# }
# transformDates("May 16")

totalTable$Date <- as.Date(sapply(lapply(totalTable$Date, FUN = function(elem) {
  if (!grepl(pattern = ".*/", elem)) {
    strTime <- sub(pattern = '(\\w{3})\\s(\\d{1,2})', replacement = "\\2\\12015", x = elem)
    as.character(format(strptime(strTime, "%d%b%Y"),"%Y/%m/%d/%m"))
  } else {
    as.character(sub(pattern = '(\\d{2})/(\\d{2})/(\\d{4})', replacement = "\\3/\\2/\\1", x = elem))
  }
}), function(x) as.character(x)))
#totalTable$Date <- as.Date(sapply(kk, function(x) as.character(x)))


# load twitter library - the rtweet library is recommended now over twitteR
library(rtweet)
library(twitteR)
# plotting and pipes - tidyverse!
library(ggplot2)
library(dplyr)
library(plyr)
# text mining library
library(tidytext)

library(tidyverse) #can we actually do R without it? I'd say no
library(ggtextures) #for glittery plots
library(extrafont) #to add personalized fonts to ggplot output
library(scales) #will be needed for percentage scales in ggplot
library(widyr) #to find correlations between songs
library(ggraph) #plotting network maps
library(igraph) #same
library(paletteer)
library(wordcloud2)
library(igraph)
library(magrittr)
library(wordcloud)
library(BSDA)
library(webshot)
library(htmlwidgets)
library(knitr)
library(tinytex)
library(lubridate)


# Key Info
appname <- "RStudio Inquiries"
key <- "ZGHxOXPzSE7WliRYCbu5UkSJj"
secret <- "vDaEPt3g8bOKohj7rCUuemrNt5UIYBM5KMmbuqehllLBppxKdS"

access_token<-"1157486996010479618-kRE1RvrrFa95aVJozBBa4AWSfwlv9P"
access_secret<- "TSYjFrudv8AF21iLnrouxunDyzKUQ4odUc2F1qKzXJ2MX"

# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)


#Collect New Tweets
new.LGBT<-search_tweets("#LGBT", n = 15000, lang="en", 
                        include_rts = FALSE, retryonratelimit = TRUE)
new.MAGA<-search_tweets("#MAGA", n = 10000, lang="en", 
                        include_rts = FALSE, retryonratelimit = TRUE)

head(new.LGBT)
head(new.MAGA)

#Load Old Tweets
load("#LGBT2.RData")
load("#MAGA2.RData")

#Combine Old and New & Check For Duplicates
LGBT2<-unique(rbind(new.LGBT,LGBT2))
MAGA2<-unique(rbind(new.MAGA,MAGA2))

#Save Combined
save(LGBT2,file="#LGBT2.RData")
save(MAGA2,file="#MAGA2.RData")

#Load Data Frames
load("#LGBT.RData")
load("#MAGA.RData")
load("#LGBT2.RData")
load("#MAGA2.RData")

LGBT<-unique(rbind(LGBT,LGBT2))
MAGA<-unique(rbind(MAGA,MAGA2))

#Only one Tweet per account every 15 minutes
sub.LGBT<-LGBT[!duplicated(cbind(LGBT$user_id,date(LGBT$created_at),
                                 round(minute(LGBT$created_at)/15)*15,hour(LGBT$created_at))),]
sub.MAGA<-MAGA[!duplicated(cbind(MAGA$user_id,date(MAGA$created_at),
                                 round(minute(MAGA$created_at)/15)*15,hour(MAGA$created_at))),]
#Combine into Single Data Frame
LGBT.Text<-data.frame(account=sub.LGBT$screen_name ,text=sub.LGBT$text, time=sub.LGBT$created_at,
                      type="LGBT",id=sub.LGBT$status_id)
MAGA.Text<-data.frame(account=sub.MAGA$screen_name ,text=sub.MAGA$text, time=sub.MAGA$created_at,
                      type="MAGA", id=sub.MAGA$status_id)
Combined<-unique(rbind(LGBT.Text,MAGA.Text))

#Total Number of Tweets
summary(Combined)

#summary(as.factor(MAGA$screen_name))
#summary(as.factor(LGBT$screen_name))

#format(object.size(sub.LGBT)/8, units = "MB")
rm(LGBT,MAGA,sub.LGBT,sub.MAGA,LGBT.Text,MAGA.Text)

head(Combined)
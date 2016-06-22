install.packages("httr")
install.packages("RJSONIO")
install.packages("twitteR")
install.packages("data.table")
install.packages("base64enc")
install.packages("tm")
install.packages("wordcloud")

library(httr)
library(RJSONIO)
library(twitteR)
library(data.table)
library(base64enc)
library(tm)
library(wordcloud)

#Set Up Authorization with Twitter
consumer_key <- "Key Here"
consumer_secret <- "Key Here"
access_token <- "Key Here"
access_secret <- "Key Here"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# Get tweets object for a particular hashtag
tweets <- searchTwitter("Keywords here",n=10000,since="2015-01-01",lang = "en",retryOnRateLimit=120)
#Convert tweets to Data frame if required
test<-twListToDF(tweets)

# Get Text from the Tweets Object
tweets.text = lapply(tweets,function(t)t$getText())
length(tweets)

#Clean Text by removing unwanted character using Cleantext.R
clean_text = clean.text(tweets.text)

# Build Text Corpus
tweet_corpus = Corpus(VectorSource(clean_text))

#Convert to TDM
tdm = TermDocumentMatrix(tweet_corpus,control = list(removePunctuation = TRUE,stopwords = c("machine", "learning", stopwords("english")),removeNumbers = TRUE, tolower = TRUE))

#Convert to Matrix with rows=words and columns=tweets
m<-as.matrix(tdm)
#Row sums for key words
word_freqs <- sort(rowSums(m), decreasing=TRUE)
#Convert to data frame
dm <- data.frame(word=names(word_freqs), freq=word_freqs)
wordcloud(dm$word, dm$freq,scale=c(5,1),min.freq=50, max.words=Inf, random.order=FALSE, random.color=TRUE, rot.per=0, colors=brewer.pal(8, "Dark2"),fixed.asp=FALSE)

png("Filename.png", width=12, height=8, units="in", res=300)

wordcloud(dm$word, dm$freq,scale=c(5,1),min.freq=50, max.words=Inf, random.order=FALSE, random.color=TRUE, rot.per=0, colors=brewer.pal(8, "Accent"),fixed.asp=FALSE)
dev.off()

rm(list = ls(all.names=TRUE))
library(httr)
library(rjson)
library(httpuv)
library(Rfacebook)

token = "EAACEdEose0cBAFrPAxpoTyniQA2AKZAFZCLERrRvPMMtFusucfVIMQvlEK3QMYKZAxuyl20DlIXQ9aw0jIlUrDX27fqh8OveVcUwZAo4STqPb7ZBq1gnkSq7zdEuZATZAVJC1SAwPdyeQiSP8XpV0zhLpzxLum3LoiHtjVWSAFNzZC8UcC3yDhtSZCTLngWiZC8Nb1fIsRrwIYsAZDZD"
url = sprintf("https://graph.facebook.com/v2.10/136845026417486_1156494751119170?fields=comments&access_token=%s",token)

res = GET(url)
data = content(res)
data1 <- matrix(unlist(data$comments$data))
comments <- data1[seq(4, length(data1), 5), ]
comments <- as.data.frame(comments)

cnt = 1

while(TRUE)
{
  if (cnt == 1)
    nexturl = unlist(data$comments$paging[2])
  else 
    nexturl = unlist(data$paging[2])
  
  nextres = GET(nexturl)
  ndata = content(nextres)
  ndata1 <- matrix(unlist(ndata$data))
  ncomments <- ndata1[seq(4, length(ndata1), 5), ]
  ncomments <- as.data.frame(ncomments)
  names(ncomments) = names(comments)
  
  comments <- rbind(comments, ncomments)  
  data <- ndata
  
  cnt = cnt + 1
  #print (names(data$paging[2]))
  if(names(data$paging[2]) == "previous") break
}

write.table(comments, file = "comments.csv")




library(KoNLP)
library(shiny)
library(ggmap)

setwd("C:/Python27/user")
info <- read.csv("age.csv")
info2 <- read.csv("gender.csv")
info3 <- read.csv("region.csv")

key <- readLines("keyword.txt", encoding="UTF-8")
key <- key[1]

path_add<-'.txt'
PODIC = scan(file='podic.txt', what = 'char', sep=',', encoding="UTF-8")
NEDIC = scan(file='nedic.txt', what = 'char', sep=',', encoding="UTF-8")
posum <- vector()
nesum <- vector()

for(i in 1:50){
  path<- paste(i, path_add, sep="")
  art<- readLines(path, encoding='UTF-8')
  nouns <- sapply(art, extractNoun, USE.NAMES = F)
  nouns <- unlist(nouns)
  POMatches <- match (nouns, PODIC)
  posum_part <- sum(!is.na(POMatches))
  posum <- rbind(posum, c(posum_part))
  NEMatches <- match (nouns, NEDIC)
  nesum_part <- sum(!is.na(NEMatches))
  nesum <- rbind(nesum, c(nesum_part))
}

f <- function(x){
  total <- 0
  for (i in 1:50){
    total <- total + x[i]
  }
  return(total)
}

pototal <- f(posum)
netotal <- f(nesum)

vj <- netotal-pototal

if(vj > 10){
  vjresult <- "부정적"
} else if(vj < -10){
  vjresult <- "긍정적"
} else{
  vjresult <- "중립적"
}

vjsen <- paste(key, "에 대해 ", vjresult, "인 반응이 우세합니다.", sep="" )

   shinyServer(function(input, output) {
   
	output$vjsentence <- renderText({vjsen})
  
    output$vjgraph <- renderPlot({
	 colors = c("pink", "skyblue")
     section<-c("positive","negative")
     score<-c(pototal,netotal)
     d<-data.frame(section,score,stringsAsFactors = FALSE)
     lbforvj =c("section","score")
     barplot(d$score,names.arg=d$section,col=colors)
	})
	
	output$agegraph <- renderPlot({
     pie(info$number, labels=info$age)
    })
	
	output$gendergraph <- renderPlot({
	 colors = c("pink", "skyblue")
     barplot(info2$number, names.arg=info2$gender, col=colors)
    })
	
	output$regiongraph <- renderPlot({
     kor <- get_map("Daejeon", zoom =7, maptype='roadmap')
     ggmap(kor) + geom_point(data = info3, aes(x =lon, y=lat, color=total, size=total))
	})
})


library(KoNLP)
library(shiny)
library(ggmap)

setwd('C:/Python27/user')
key <- readLines("keyword.txt", encoding="UTF-8")
key <- key[1]
path_add<-'.txt'

count <- 1  
for(i in 1:50){
  path<-paste(i, path_add, sep="")
  art<-readLines(path, encoding='UTF-8')
  for(j in 1:length(art)){
    sen<-strsplit(art[j], fixed=TRUE, split=". ")
    data<-unlist(sen)
    for(k in 1:length(data)){
      obj1<-data[k][grep("따르면", data[k])]
      obj1<-gsub("(^ +)|( +$)", "", obj1)
      if(length(obj1)!=0){
        if(grepl("‘", obj1) | grepl("'", obj1)){
          obj1 <- NULL
        }
        else {
		  objfile <- paste("obj", count, ".txt", sep="")
		  write(obj1, file=objfile)
		  count <- count + 1
        }
      }
      obj2<-data[k][grep("밝혔다", data[k])]
      obj2<-gsub("(^ +)|( +$)", "", obj2)
      if(length(obj2)!=0){
        if(grepl("‘", obj2) | grepl("'", obj2)){
          obj2 <- NULL
        }
        else {
          objfile <- paste("obj", count, ".txt", sep="")
		  write(obj2, file=objfile)
		  count <- count + 1
        }
      }
    }
  }
}

objarr <- vector()

for (i in 1:5){
  objfilefinal <- paste("obj", i, ".txt", sep="")	  
  obj <- readLines(objfilefinal, encoding="ANSI")
  obj <- obj[1]
  objarr[i] <- obj
}
  
keyword <- paste(key, "에 대한", sep="")
objective <- paste(key, "에 대한 객관적 사실들은")
user <- paste(key, "을(를) 검색한 사용자는")

shinyUI(fluidPage(
  
  includeCSS("styles.css"),

  navbarPage("",
	tabPanel(img(src="TMLOGO.png", height="100", width="100")),
    navbarMenu(span(br(), br(), keyword, style="font-size:25px;"),
		tabPanel("반응", tags$h2(textOutput("vjsentence")), plotOutput("vjgraph")),
		tabPanel("객관적 문장", tags$h4(objarr[1]), br(), br(), 
					tags$h4(objarr[2]), br(), br(), 
					tags$h4(objarr[3]), br(), br(), 
					tags$h4(objarr[4]), br(), br(), 
					tags$h4(objarr[5]))),
	navbarMenu(span(br(), br(), user, style="font-size:25px;"),
		tabPanel("연령", plotOutput("agegraph")),
		tabPanel("성별", plotOutput("gendergraph")),
		tabPanel("지역", plotOutput("regiongraph"))
	))
))

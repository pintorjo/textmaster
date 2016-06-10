library(KoNLP)
library(shiny)
library(ggmap)

setwd('C:/Python27/user')
path_add<-'.txt'
PODIC = scan(file='podic.txt', what = 'char', sep=',', encoding="UTF-8")
NEDIC = scan(file='nedic.txt', what = 'char', sep=',', encoding="UTF-8")
key <- readLines("keyword.txt", encoding="UTF-8")
key <- key[1]
posum <- vector()
nesum <- vector()

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

objarr <- vector()

# 5개
for (i in 1:5){
  objfilefinal <- paste("obj", i, ".txt", sep="")	  
  obj <- readLines(objfilefinal, encoding="ANSI")
  obj <- obj[1]
  objarr[i] <- obj
}
  

#key <- as.character(key)
keyword1 <- paste(key, "에 대한", sep="")
keyword2 <- paste(key, "에 대해 ", vjresult, "인 반응이 우세합니다.", sep="" )
objective <- paste(key, "에 대한 객관적 사실들은")
user <- paste(key, "을(를) 검색한 사용자는")

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  includeCSS("styles.css"),
  # Application title
 
  navbarPage("",
	tabPanel(img(src="TMLOGO.png", height="100", width="100")),
    navbarMenu(span(br(), br(), keyword1, style="font-size:25px;"),
		tabPanel("반응", tags$h2(keyword2), plotOutput("vjgraph")),
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
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
    
    # Show a summary of the dataset and an HTML table with the 
	 # requested number of observations
    #mainPanel(
      #tabsetPanel(
		#tabPanel("vjgraph", plotOutput("vjgraph")) 
		#tabPanel("agegraph", plotOutput("agegraph"), 
	  #),
      #tags$div(class = "header", checked = NA,
        #tags$h2(keyword),
		
		#plotOutput("vjgraph"),
		#tags$h2(objective),
		#tags$p(objarr[1]),
		#tags$p(objarr[2]),
		#tags$h2(user),
		#splitLayout(
			#plotOutput("agegraph"), 
			#plotOutput("gendergraph")
		#)
		#),

      #tags$div(class="header", checked = NA,
        #tags$h2(objective),
		#),
	  
		#tags$p(objarr[1]),
		#tags$p(objarr[2]),
        #tags$p(objarr[3]),
		#tags$p(objarr[4]),
		#tags$p(objarr[5]),
      
	  #tags$div(class="header", checked = NA,
        #tags$h2(user),
	  
	    #splitLayout(
		  #plotOutput("agegraph"), 
	      #plotOutput("gendergraph")
		#),
		
	    #plotOutput("regiongraph")
	  
	#)))

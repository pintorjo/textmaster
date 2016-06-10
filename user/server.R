library(shiny)
library(ggmap)

setwd("C:/Python27/user")
info <- read.csv("age.csv")
info2 <- read.csv("gender.csv")
info3 <- read.csv("region.csv")

# Define server logic required to summarize and view the selected
# dataset

   shinyServer(function(input, output) {
  #긍정적입니다
  
  # Fill in the spot we created for a plot
    output$vjgraph <- renderPlot({
	 colors = c("pink", "skyblue")
     section<-c("positive","negative")
     score<-c(pototal,netotal)
     d<-data.frame(section,score,stringsAsFactors = FALSE)
     lbforvj =c("section","score")
     barplot(d$score,names.arg=d$section,col=colors)
	})
	
   #객관적사실
	
	output$agegraph <- renderPlot({
     #lbforage <- c("10s", "20s", "30s", "40s", "over50s")
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


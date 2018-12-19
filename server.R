#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(rpart)
library(randomForest)
library(kableExtra)
library(dplyr)
library (e1071)
library(FSelector)

shinyServer(function(input, output,session) {
      
      set.seed(1000)
      
      tb <- read.csv("selectedfeature.csv", sep =",")
      
      tb <- tb[!is.na(tb$Importance),]
      
      output$distPlot <- renderPlot({
            ggplot(tb, aes(x=FeatureName,y=Importance)) + geom_col(width = 0.8) + theme(axis.text.x = element_text(size = 8, angle = 90,hjust=1,vjust=0.5)) + xlab("Features") + ylab("Importance") + labs(title = "Importance of features") + scale_x_discrete(limits = tb$FeatureName)
      })
      
      train2 <- read.csv("cleantrain.csv", sep =",")
      train2 <- train2[,-1]
      subindex <- createDataPartition(train2$classe, p = 0.7, list = F) 
      crosstrain <- train2[subindex,]
      crosstest <- train2[-subindex,]
    
       model <- reactive({
       input$act
        brushed_data <- isolate(brushedPoints(tb, input$brush1, xvar = "FeatureName",yvar = "Importance"))
     
        idx <- brushed_data[,1]  # row number
        #assign("nfe",length(idx),envir = .GlobalEnv)
        nfe <<- length(idx)
        idx <- as.character(tb[idx,1])
        ff <- as.simple.formula(idx,"classe")
        if (input$pred == "Random Forest") {
             m <-  rpart(ff,data = crosstrain)
             cfm <- confusionMatrix(predict(m, crosstest, type = "c"),crosstest$classe)
        }
        else if (input$pred == "Decision Tree") {
              m <-  rpart(ff,data = crosstrain)
             cfm <- confusionMatrix(predict(m, crosstest, type = "c"),crosstest$classe)
        }
        list(nfe=nfe,cfm=cfm)
  })
  
  output$accuracy <- renderText({
       if(input$act) as.character(model()$cfm$overall["Accuracy"])
  }) 
  output$nf <- renderText({
        if(input$act) model()$nfe
       }) 
  output$cf <- renderPrint({
        if(input$act) model()$cfm$table
  }) 
  
})


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Should we choose as many predictors as we can?"),

  sidebarLayout(
    sidebarPanel(
       h6("NOTE!!!: It can take a while to display the plot"),
       h6("1. Draw a box on the plot to choose predictors"),
       h6("2, Choose prediction method"),
       h6("3. Click the predict button"),
       h6("Note: Random forest caused out of memory on shinny server so it is actually rpart. So don't be suprised if they give the same results"),
       selectInput("pred","Method:",c("Decision Tree","Random Forest")),
       actionButton("act","Predict"),
       h6("Number of selected features:"),
       textOutput("nf")
       #textOutput("accuracy")
    ),
    
    mainPanel(
       tabsetPanel(type = "tabs",
       tabPanel("Prediction",          
       plotOutput("distPlot", brush = brushOpts(id = "brush1")),
       
       h5("Prediction Accuracy:"), 
       textOutput("accuracy"),
       h5("Confusion table:"),
       verbatimTextOutput("cf")),
       tabPanel("Documentation","
                This application aims to show the importance of choosing features for machine learning algorithm.
                The example dataset is taken from the data collected by activity bands to predict type of movememt (this dataset was used in machine learning class).
                There are in fact many predictors but this app only shows the first 40 features ranked by the Var.Imp function.
                By choosing different set of features, we would be able to see the impact of features on the prediction accuracy. 
                It will give some feeling on the impact of the numbers of features, and type of features, etc. 
                " )
       )
       
    )
  )
))

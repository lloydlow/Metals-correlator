library(shiny)
library(quantmod)
library(ggplot2)
library(scales)
library(plotly)
# Define UI for dataset viewer application
fluidPage(
  
  # Application title
  titlePanel("Metals correlation"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("caption", "Caption:", "Metals weekly correlation"),
      
      selectInput("metal1", "Choose first metal:", 
                  choices = c("gold", "silver", "platinum","palladium"),selected = "silver"),
      selectInput("metal2", "Choose second metal:", 
                  choices = c("gold", "silver", "platinum","palladium"))
      ),

    mainPanel(
      h3(textOutput("caption", container = span)),
      tabsetPanel(
        tabPanel("Plot",plotlyOutput("plot1")),
        tabPanel("Table",dataTableOutput("metalComp"))
      )
    )
  )
)
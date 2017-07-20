library(shiny)
library(quantmod)
library(ggplot2)
library(scales)
library(plotly)

function(input, output) {
  
  output$caption <- renderText({
    input$caption
  })
  
  # By declaring metal1Input and metal2Input as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #	  (it only executes a single time)
  #
  metal1Input <- reactive({
    switch(input$metal1,
            gold = "XAU/USD",
            silver = "XAG/USD",
            platinum = "XPT/USD",
            palladium = "XPD/USD")
  })
  
  metal2Input <- reactive({
    switch(input$metal2,
           gold = "XAU/USD",
           silver = "XAG/USD",
           platinum = "XPT/USD",
           palladium = "XPD/USD")
  })
  
  output$metalComp <- renderDataTable({
    met1 <- metal1Input()
    x <- getFX(met1,auto.assign = FALSE)
    x <- data.frame(x)
    x$date = as.Date(rownames(x))
    colnames(x)[1] = 'price'
    #x
    met2 <- metal2Input()
    y <- getFX(met2,auto.assign = FALSE)
    y <- data.frame(y)
    y$date = as.Date(rownames(y))
    colnames(y)[1] = 'price'
    #y
    cor_vec <- c()
    corDate <- c() 
    for (i in 1:(nrow(x)-6)){
      vec <- cor(x$price[i:(i+6)],y$price[i:(i+6)])
      cor_vec <- c(cor_vec,vec)
      corDate <- c(corDate,x$date[i+6])
    }
    class(corDate) <- "Date"
    
    metalCompareDF <- as.data.frame(cbind(cor_vec,corDate))
    colnames(metalCompareDF) <- c("Cor","Date")
    metalCompareDF$Date <- as.Date(metalCompareDF$Date)
    metalCompareDF
  })
  
  output$plot1 <- renderPlotly({
    met1 <- metal1Input()
    x <- getFX(met1,auto.assign = FALSE)
    x <- data.frame(x)
    x$date = as.Date(rownames(x))
    colnames(x)[1] = 'price'
    #x
    met2 <- metal2Input()
    y <- getFX(met2,auto.assign = FALSE)
    y <- data.frame(y)
    y$date = as.Date(rownames(y))
    colnames(y)[1] = 'price'
    #y
    cor_vec <- c()
    corDate <- c() 
    for (i in 1:(nrow(x)-6)){
      vec <- cor(x$price[i:(i+6)],y$price[i:(i+6)])
      cor_vec <- c(cor_vec,vec)
      corDate <- c(corDate,x$date[i+6])
    }
    class(corDate) <- "Date"
    
    metalCompareDF <- as.data.frame(cbind(cor_vec,corDate))
    colnames(metalCompareDF) <- c("Cor","Date")
    metalCompareDF$Date <- as.Date(metalCompareDF$Date)
    metalCompareDF
    
    g <- ggplot(data=metalCompareDF, aes(x=Date, y=Cor)) 
    g <- g + geom_line() + scale_x_date(labels = date_format("%m-%Y")) + theme_bw()
    ggplotly(g)
    
  })

}

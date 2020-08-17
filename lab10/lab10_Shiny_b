#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(ggplot2)

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   #verbatimTextOutput
  output$change <- renderText({
    #reactive(
    
    
    # generate bins based on input$bins from ui.R
    reactive({
    DDT[14]   <- DDT[14] + input$change
    })
    
    paste("Média: ", round(mean(DDT), 3) ,"\n",
          "Mediana: ", round(median(DDT), 3) , "\n",
          "Desvio padrão: ", round(sd(DDT), 3), "\n",
          "IQR: ", round(IQR(DDT)/1.349, 3))
    
    
    #)
  })
  output$cgrafico <- renderPlot({
    reactive({
      DDT[14]   <- DDT[14] + input$change
    })
    meansd <- dnorm(DDT, mean = mean(DDT), sd = sd(DDT) )
    medianiqr <- dnorm(DDT, mean = median(DDT), sd = IQR(DDT)/1.349 )

    f1 <- function(x) dnorm(x, mean = mean(DDT), sd = sd(DDT) )
    f2 <- function(x) dnorm(x, mean = median(DDT), sd = IQR(DDT)/1.349 )
    hist(DDT, col = "Grey", freq = FALSE)
    curve(f1, add = TRUE, col = "red")
    curve(f2, add = TRUE, col = "blue")
    
    # ggplot(data = data.frame(DDT), mapping = aes( x = DDT)) +
    #   geom_histogram() + #como coloco a densidade de prob?
    #   geom_density(aes(meansd), col = "red") +
    #   geom_density(aes(medianiqr), col = "blue")
  })

  output$tabela <- renderTable({
    reactive({
    coluna <- input$cols
    limite <- input$obs
    })
    
    #Vai usar os dados para fazer a chamada ao banco
    
  })
  
})



shinyApp(ui, server)

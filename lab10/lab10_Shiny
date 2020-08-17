#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("Atividade: Shiny"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("change",
                   "Correção:",
                   min = -4,
                   max = 10,
                   value = 0),
    
       selectInput("cols", "Coluna:", c("a", "b")), #colocar a lista de colunas
       numericInput("obs", "Observações:", 5, min = 1, max = 10)
        ),
    
    # Show a plot of the generated distribution
    mainPanel(
       textOutput("change"),
       plotOutput("cgrafico"),
       tableOutput("tabela")
    )
  )
  
))

#shinyApp(ui, server)

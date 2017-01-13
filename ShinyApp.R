library(shiny)
library(ggplot2)
library(shinythemes)
library(knitr)
library(markdown)

ui <- fluidPage(title = "Zarobki",theme = shinytheme("cyborg"),
                h3("Informacje dotycz¹ce ofert pracy znalezionych na stronie www.pracuj.pl"),
                fluidRow(
                  column(4,
                         selectInput("Lokalizacja",
                                     "Lokalizacja:",
                                     c("Wszystkie",
                                       unique((as.character(data$Lokalizacja))))
                                     )
                         )
                ),
                
                dataTableOutput("data"),
            
                mainPanel(
                  tabsetPanel(
                    tabPanel("Wykres",plotOutput("wykres",width = 850,height = 500)),
                    tabPanel("Raport",uiOutput('markdown'))
                  )
                  
                )
  
)

server <- function(input, output) {
  
  showModal(modalDialog(
    title = "Witaj!",
    h3("Aplikacja prezentuj¹ca oferty pracy z pracuj.pl"),
    easyClose = TRUE
  ))
  
  output$data = renderDataTable({
    data
    if (input$Lokalizacja != "Wszystkie"){
      data <- data[data$Lokalizacja == input$Lokalizacja,]
    }
    data
  })
  
  h2 <-qplot(data=data, x=Lokalizacja, y=Wynagrodzenie, colour=Wynagrodzenie, size=I(4))
  output$wykres<-renderPlot(h2, width = "auto", height = "auto")
    
  
  output$markdown <- renderUI({
    includeMarkdown("C:/Users/Komputer/Documents/Webscraper_Pawel.Rmd")
  })
  
  # output$markdown <- renderUI({
  #   HTML(markdown::markdownToHTML(knit('C:/Users/Komputer/Documents/Webscraper_Pawel.Rmd', quiet = TRUE)))
  # })
  

}

shinyApp(ui = ui, server = server)
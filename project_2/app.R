library(shiny)
library(shinydashboard)
# setwd('~/Documents/GitHub/bios611-projects-fall-2019-Jianqiao-Wang/project_2/')
source('helper_functions.R')

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Project 2"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Background", tabName = "background", icon = icon("Background")),
      menuItem("Purpose of Analysis", tabName = "purpose", icon = icon("Purpose of Analysis")),
      menuItem("Analysis", tabName = "analysis", icon = icon("Purpose of Analysis"),
               menuSubItem("Question 1-3", tabName = "Q1-3", icon = icon("Question 1-3")),
               menuSubItem("Question 4", tabName = "Q4", icon = icon("Question 2")))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "background",
        htmlOutput("background")
      ), 
      tabItem(tabName = "purpose",
        htmlOutput("purpose")
      ),
      tabItem(tabName = "Q1-3",
        fluidRow(
          sidebarPanel(
            selectInput('trend_variable',
                        'Type of Help UMD Provided',
                        c("Number of People Receiving Food", "Food Pounds", "Clothing Items")
            )
          ),
          mainPanel(
            plotOutput("trend_plot"),
            htmlOutput("trend_interpretation")
          )
        )
      ),
      
      tabItem(tabName = "Q4",
          mainPanel(
            plotOutput("average_food"),
            htmlOutput("average_food_interpretation")
          ),
          sidebarPanel(
            calculator,
            selectInput('group',
                        'Group',
                        c(1, 2)
            ),
            numericInput('number_of_people',
                         'Number of People',
                         value=1, min=1, max=60, step=1
            ),
            textOutput("food_pounds")
          )
      )
    )
  )
)

server <- function(input, output) {
  set.seed(435)
  output$background <- renderUI({
   HTML(paste(umd_description, data_description, sep="<br/>"))
  })
  output$purpose <- renderUI({
    HTML(paste("<ul><li>", purpose[1], 
               "</li><li>", purpose[2], 
               "</li><li>", purpose[3],
               "</li><li>", purpose[4], "</li><ul>"))
  })
  output$trend_plot <- renderPlot({
    trend(input$trend_variable)
  })
  output$trend_interpretation <- renderUI({
    HTML(paste("<ul><li>", trend_interpretation[input$trend_variable][1,], 
               "</li><li>", trend_interpretation[input$trend_variable][2,], 
               "</li><li>", trend_interpretation[input$trend_variable][3,], "</li><ul>"))
  })
  
  output$average_food <- renderPlot({
    average_food_plot
  })
  output$average_food_interpretation <- renderUI({
    HTML(paste("<ul><li>", average_food_interpretation[1], 
               "</li><li>", average_food_interpretation[2], 
               "</li><li>", average_food_interpretation[3],
               "</li><li>", average_food_interpretation[4],
               "</li><li>", average_food_interpretation[5],
               "</li><li>", average_food_interpretation[6],
               "</li><li>", average_food_interpretation[7],
               "</li><ul>"))
  })
  
  output$food_pounds <- renderText({
    if (input$group==1) {
      paste('Estimated Food Pounds UMD should provide for', input$number_of_people, ' people in Group One:', round(model$one$coefficients * input$number_of_people, 2), 'pounds')
    } else {
      paste('Estimated Food Pounds UMD should provide:', input$number_of_people, ' people in Group Two:',round(model$two$coefficients * input$number_of_people, 2), 'pounds')
    }})
  
}

# Run the application 
shinyApp(ui = ui, server = server)
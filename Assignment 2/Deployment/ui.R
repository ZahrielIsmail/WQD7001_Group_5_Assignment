library(shiny)
library(shinydashboard)
library(shinyjs)
library(rlang)
library(randomForest)


    header <- dashboardHeader(
      title = "Airline Passenger satisfaction Prediction",
      titleWidth = 900,
      tags$li(class = "dropdown", tags$a(href = "https://github.com/IzzulI/Shinyapp_WQD7001", icon("github"), "Source Code", target = "_blank"))
    )

    sidebar <- dashboardSidebar(
      sidebarMenu(
        id = "sidebar",
        menuItem("Title", tabName = "info", icon = icon("database")),
        menuItem("Statistics Visualisation", tabName = "visual", icon = icon("map")),
        menuItem("Prediction Model", tabName = "pm", icon = icon("computer"))
      )
    )

    body <- dashboardBody(tags$style(HTML('.skin-blue .main-header .navbar {background-color: #DAA520}
                                           .skin-blue .main-header .logo {background-color: #DAA520}
                                           .skin-blue .main-header .logo:hover {background-color: #DAA520}
                                           .skin-blue .main-sidebar {background-color: #494949;}
                                           .skin-blue .main-sidebar .sidebar .sidebar-menu .active a {background-color: #DAA520}
                                           .skin-blue .main-sidebar .sidebar .sidebar-menu .active a:hover {background-color: #DAA520}
                                           .skin-blue .main-header .navbar .sidebar-toggle:hover {background-color: #DAA520}
                                           .content-wrapper, .right-side {background: linear-gradient(to bottom, white, #FFEBCD)}
                                          ')),
      tabItems(
      tabItem(
        tabName = "info",
        fluidRow(
          column(
            width = 8,
            h2("Introduction"),
            tags$img(src = "cover.png", width = 800, height = 520)
          )
        )
      ),
      tabItem(
        tabName = "visual",
        fluidRow(
  #        column(
            width = 12,
            h2("Statistics Visualisation"),
            fluidRow(
              column(width = 4, tags$img(src = "img1.png", width = 300, height = 200)),
              column(width = 4, tags$img(src = "img2.png", width = 300, height = 200)),
              column(width = 4, tags$img(src = "img3.png", width = 300, height = 200)),
              column(width = 4, tags$img(src = "img4.png", width = 300, height = 200)),
              column(width = 4, tags$img(src = "img5.png", width = 300, height = 200)),
              column(width = 4, tags$img(src = "img6.png", width = 300, height = 200))

            )
 #         )
        ),
            fluidRow(hr()),
            fluidRow(
              column(width = 4, tags$img(src = "img7.png", width = 400, height = 300)),
              column(width = 4, tags$img(src = "img8.png", width = 400, height = 300)),
              column(width = 4, tags$img(src = "img9.png", width = 400, height = 300))
            )
          )
      ,
      tabItem(
        tabName = "pm",
        fluidPage(
          fluidRow(hr()),
          h4("Input Attributes"),
          fluidRow(
            box(width=12,style = "color: #494949; background: linear-gradient(to bottom, #FFFFE0, #DAA520)",
              fluidRow(
                column(4, selectInput("gender", "Gender", c("Female", "Male"))),
                column(4, selectInput("customer_type_first_time", "First Time", c("First Time", "Returning"))),
                column(4, selectInput("age_category", "Age Category", c("Adult", "Child", "Adolescent", "Elderly"))),
                column(4, selectInput("travel_type","Travel Type",c("Personal","Business"))),
                column(4, selectInput("class","Class",c("Economy","Economy Plus","Business"))),
                column(4, selectInput("flight_category","Flight Category",c("Short","Medium","Long"))),
                column(4,numericInput("departure_and_arrival_time_convenience","Depart & Arrival time convenience",5, min=1,max=5)),
                column(4,numericInput("ease_of_online_booking","Ease of online booking",5, min=1,max=5)),
                column(4,numericInput("check_in_service","Check in Service",5, min=1,max=5)),
                column(4,numericInput("online_boarding","Online Boarding",5, min=1,max=5)),
                column(4,numericInput("gate_location","Gate Location",5, min=1,max=5)),
                column(4,numericInput("on_board_service","On Board Service",5, min=1,max=5)),
                column(4,numericInput("seat_comfort","Seat Comfort",5, min=1,max=5)),
                column(4,numericInput("leg_room_service","Leg Room",5, min=1,max=5)),
                column(4,numericInput("cleanliness","Cleanliness",5, min=1,max=5)),
                column(4,numericInput("food_and_drink","Food & drink",5, min=1,max=5)),
                column(4,numericInput("in_flight_service","Inflight Service",5, min=1,max=5)),
                column(4,numericInput("in_flight_wifi_service","Inflight WIFI",5, min=1,max=5)),
                column(4,numericInput("in_flight_entertainment","Inflight entertainment",5, min=1,max=5)),
                column(4,numericInput("baggage_handling","Baggage Handling",5, min=1,max=5)),
                column(4,numericInput("departure_delay","Departure Delay",0, min=0,max=5000)),
                column(4,numericInput("arrival_delay","Arrival Delay",0, min=0,max=5000))
              )
            ),
          ),
          fluidRow(
            column(6, actionButton("predict", "Predict", style = "vertical-align:bottom; color: #FFFFE0; background-color: #DAA520", class = "btn-primary"))
          ),
          fluidRow(hr()),
          h4("Prediction Output"),
          fluidRow(
            div(
              id = "results",
              fluidRow(width=12,verbatimTextOutput("output_msg")),
              fluidRow(hr()),
              fluidRow(column(12, align = "center", uiOutput("image")))
            )
          )
        )
      )
    )
  )
    
ui <- dashboardPage(header,sidebar,body)

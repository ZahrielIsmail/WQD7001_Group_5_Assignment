shinyServer(function(input, output, session) {
  
  library(shiny)
  library(tidyverse)
  library(caret)
  library(glue)
  
  
  read_modellist <- readRDS("model/RFModel.rds")
  model_shiny <- read_modellist[[1]]
  
  recommend_action <- function(input, output){
    
    values <- reactiveValuesToList(input)
    
    
    gender_female <- if(values$gender == "Female"){1} else {0}
    customer_type_first_time <- if(values$customer_type_first_time == "First Time"){1} else {0}
    age_category_child = if(values$age_category == "Child"){1} else {0}
    age_category_adolescent = if(values$age_category== "Adolescent"){1} else {0}
    age_category_adult = if(values$age_category == "Adult"){1} else {0}
    age_category_elderly = if(values$age_category == "Elderly"){1} else {0}
    flight_distance_category_long_distance = if(values$age_category == "Long"){1} else {0}
    flight_distance_category_medium_distance = if(values$age_category == "Medium"){1} else {0}
    flight_distance_category_short_distance = if(values$age_category == "Short"){1} else {0}
    class_business = if(values$class == "Business"){1} else {0}
    class_economy = if(values$class == "Economy"){1} else {0}
    class_economy_plus = if(values$class == "Economy Plus"){1} else {0}
    
    
    input_df <- data.frame(gender_female = gender_female,
                           customer_type_first_time = customer_type_first_time ,
                           age_category_adolescent = age_category_adolescent,
                           age_category_adult= age_category_adult ,
                           age_category_child= age_category_child ,
                           age_category_elderly= age_category_elderly,
                           flight_distance_category_long_distance= flight_distance_category_long_distance,
                           flight_distance_category_medium_distance= flight_distance_category_medium_distance,
                           flight_distance_category_short_distance = flight_distance_category_short_distance ,
                           departure_delay= values$departure_delay,
                           arrival_delay= values$arrival_delay,
                           type_of_travel_business= class_business,
                           class_business= class_business,
                           class_economy= class_economy,
                           class_economy_plus= class_economy_plus,
                           departure_and_arrival_time_convenience= values$departure_and_arrival_time_convenience,
                           ease_of_online_booking= values$ease_of_online_booking,
                           check_in_service= values$check_in_service,
                           online_boarding= values$online_boarding,
                           gate_location= values$gate_location,
                           on_board_service= values$on_board_service,
                           seat_comfort= values$seat_comfort,
                           leg_room_service= values$leg_room_service,
                           cleanliness= values$cleanliness,
                           food_and_drink= values$food_and_drink,
                           in_flight_service= values$in_flight_service,
                           in_flight_wifi_service= values$in_flight_wifi_service,
                           in_flight_entertainment= values$in_flight_entertainment,
                           baggage_handling= values$baggage_handling)
    
    predicted_value <- predict(model_shiny, input_df)
    predicted_value <- as.character(predicted_value)
    predicted_value_df <- data.frame(predicted_value)
    colnames(predicted_value_df) <- "predicted_value"
    gender_ind <- input_df[nrow(predicted_value_df),1]
    predicted_value_df$predicted_value[predicted_value_df$predicted_value == "X0"] <- "Neutral or Dissatisfied"
    predicted_value_df$predicted_value[predicted_value_df$predicted_value == "X1"] <- "Satisfied"
    output_var <- predicted_value_df[nrow(predicted_value_df),"predicted_value"]
    output_message <- glue("The passenger is most likely {output_var} with his flight experience")
    
    output$output_msg <- renderText(output_message)
    
    output$image <- renderUI({
      if(output_var=="Satisfied")
        {img(src='happy.png', width = 300, height = 300)}
      else
        {img(src='sad.png', width = 300, height = 300)}
    })
    
    }
    
  
  observeEvent(input$predict, recommend_action(input,output))
  
})





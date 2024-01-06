#Combined Initial Steps


#Setting Path and dataset (Change path to current folder with dataset)
setwd("C:/Users/user/Desktop/University/Principles of Data Science/Group Project 1/Datasets")
dataset = read.csv("airline_passenger_satisfaction.csv")

#Required Libraries

library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(janitor)
library(mice)
library(skimr)
library(data.table)

#Binning Age

#NIH Age Definition
#Children 1-12
#Adolescents 13-17
#Adults 18 - 65
#Elderly 66+

age_groups = list(Child = c(0,12),Adolescent = c(13,17),Adult = c(18,65),Elderly = c(66,Inf))
AgesDataset = data.frame(dataset$Age)
AgeCategories = character(length(dataset$Age))
AgeCategories = data.frame(matrix(ncol = 1,nrow = length(dataset$Age)))

for (obj in seq_along(dataset$Age)){
  for(category in names(age_groups)){
    age_range = age_groups[[category]]
    if(AgesDataset$dataset.Age[obj]>= age_range[1] & AgesDataset$dataset.Age[obj] <= age_range[2]){
      AgeCategories[obj,1]= category
      break
    }
  }
}

names(AgeCategories)[1] = "Age Category"
AgeGroupDataset = cbind(dataset,AgeCategories)
AgeGroupDataset = AgeGroupDataset %>% select(-Age)
AgeGroupDataset = AgeGroupDataset %>% select(ID,Gender,Customer.Type,`Age Category`,everything())


#Binning Distance

#Definition of Flight Distances
#Short 0-1000
#Medium 1000-3000
#Long 3000+

distance_groups = list("Short Distance" = c(0,1000),"Medium Distance" = c(1000,3000),"Long Distance" = c(3000,Inf))
DistanceDataset = data.frame(dataset$Flight.Distance)
DistanceCategories = character(length(dataset$Distance))
DistanceCategories = data.frame(matrix(ncol = 1,nrow = length(dataset$Flight.Distance)))

for (obj in seq_along(dataset$Flight.Distance)){
  for(category in names(distance_groups)){
    distance_range = distance_groups[[category]]
    if(DistanceDataset$dataset.Flight.Distance[obj]>= distance_range[1] & DistanceDataset$dataset.Flight.Distance[obj] <= distance_range[2]){
      DistanceCategories[obj,1]= category
      break
    }
  }
}

names(DistanceCategories)[1] = "Flight Distance Category"
DistanceGroupDataset = cbind(AgeGroupDataset,DistanceCategories)
DistanceGroupDataset = DistanceGroupDataset %>% select(-Flight.Distance)
DistanceGroupDataset = DistanceGroupDataset %>% select(ID,Gender,Customer.Type,`Flight Distance Category`,everything())

View(DistanceGroupDataset)

#MICE Prediction for missing values

dataset = clean_names(dataset)

#define function to impute using mice method:predictive mean matching
impute_func = function(df){
  imp_model = df %>% mice(m=1, maxit = 50, method = c("pmm"))
  as_tibble(complete(imp_model,1))
}

#airline_df is the original, airline_df_imp is the new df with updated missing value
airline_df_imp <- impute_func(dataset)

#to see the arrival delay new distribution
skim(airline_df_imp)

DistanceGroupDataset = DistanceGroupDataset %>% select(-Arrival.Delay)
FinalDataset = cbind(DistanceGroupDataset,airline_df_imp$arrival_delay)
names(FinalDataset)[24] = "Arrival.Delay"
FinalDataset = FinalDataset %>% select(ID,Gender,Customer.Type,`Age Category`,`Flight Distance Category`,`Departure.Delay`,`Arrival.Delay`,everything())
View(FinalDataset)


# Export
write.csv(FinalDataset,"Processed Airline Passenger Satisfaction.csv",row.names=FALSE)

# EDA Report
dataset = read.csv("Processed Airline Passenger Satisfaction.csv")
factorer = c("Departure.and.Arrival.Time.Convenience","Ease.of.Online.Booking", "Check.in.Service","Gate.Location","On.board.Service","Seat.Comfort","Leg.Room.Service","Cleanliness","Food.and.Drink","In.flight.Wifi.Service","In.flight.Entertainment","Baggage.Handling","In.flight.Service","Online.Boarding","ID")
dataset[factorer] = lapply(dataset[factorer],factor)

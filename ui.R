################################################################################################################################################################
#	Coder:Szabolcs Sandoly																																		
#	Date: 19-06-2014
#	Developing Data Products, Coursera
#	Developed in R-Studio using Shiny + Highcharts (Column range)
################################################################################################################################################################
#This application calculates calories and macronutrients (carbohydrate, fat, protein) intake need based on users input of age, height in cm, and weight in kg.      
#Upon entering the requested data, two calculation method are applied on it, so thus the user get 																
#	a) the Mifflin-St.Jeor prediction on energy needs based on activity level,
#	b) required calories per body weight to meet desired outcome (lose, maintain or gain weight).  
################################################################################################################################################################
#Basic information about calculation#
#####################################
#Daily Energy Needs: Mifflin-St.Jeor Predictive Equation 
#
# Men:    RMR (Resting Metabolic Rate) =  9.99 X weight [kg] + 6.25 X height [cm] – 4.92 X age + 5
# Women:  RMR =  9.99 X weight [kg] + 6.25 X height [cm] – 4.92 X age - 161
# 
# Account activity level:
#	- sedentary (little or no exercise) : RMR x 1.2
#	- lightly active (light exercise/sports 1-3 days/week) : RMR x 1.375 
#	- moderately active (moderate exercise/sports 3-5 days/week) : RMR x 1.55 
#	- very active (hard exercise/sports 6-7 days a week) : RMR x 1.725
#	- extra active (very hard exercise/sports and physical job or 2x training) : RMR x 1.9 
#       
#			Energy Needs: calories /kg
#
# 	÷To lose weight: 20-25 calories per kg body weight
# 	÷To maintain weight: 25-30 calories per kg body weight
# 	÷To gain weight: 30-35 calories per kg body weight
# Note:
# Days with no exercise: use lower end of range
# Days with no exercise: use upper end of range
#
#       Macronutrient Distribution Ranges
#
#                 Macronutrient Distribution Range: Percent of Energy/Calories
#Macronutrient  || Children, 1-3 years  || Children, 4-18 years || Adults > 18 years
#------------------------------------------------------------------------------------
# Carbohydrate  ||  45-65%              ||  45-65%              ||  45-65%
# Fat           ||  30-40%              ||  25-33%              ||  20-35%
# Protein       ||  5-20%               ||  10-30%              ||  10-35%
#------------------------------------------------------------------------------------
#
# Daily need of carbohydrates, fat, protein in grams:
#  Carbohydrate: 4 calories per g carbohydrate
#  Fat         : 9 calories per g fat
#  Protein     : 4 calories per g protein   

library(shiny)
library(rCharts)

shinyUI(fluidPage( theme = "bootstrap.css",
  #headerPanel(),

  sidebarLayout(
              
	sidebarPanel	(
				titlePanel("Daily Energy Intake Calculator", windowTitle = "Calories Calculator"),
				numericInput("age", h4("Age:"), 20, min = 0, max = 110),
				radioButtons("gender", label = h4("Select gender"), c("Female" = "Female", "Male" = "Male")),
				numericInput("weight", h4("Weight in kilograms:"), 45, min = 1, max = 200),
				numericInput("height", h4("Height in centimeters:"), 160, min = 25, max = 250), hr(),
				#submitButton('Calculate')
				 h4('You entered:'),
				 h4('Age'),
				textOutput("age"), 
				 h4('Gender'),
				 textOutput("gender"), 
				 h4('Weight in kilograms'),
				 textOutput("weight"), 
				 h4('Height in centimeters'),
				 textOutput("height")
  
				),
	mainPanel( width=7,
			h3("Comparison of Mifflin St. Jeor's Metabolic Rate vs. Calories per Body Weight Method"), hr(),
			h3('Calculation 1: Mifflin-St. Jeor method'),hr(),
			selectInput("activity", label = h4("Select activity level:"), c("Resting metabolic rate" = 1 ,"Sedentary (little or no exercise)" = 2, "Lightly active (light exercise/sports 1-3 
													days/week) " = 3, "Moderately active (moderate exercise/sports 3-5 days/week)" = 4, "Very active (hard exercise/sports 6-7 days a week)" = 5, "Extra active (very hard exercise/sports and physical job or 2x training)" = 6 ), selected = 0),		
			h4('Calories need for desired outcome: '),
			tabsetPanel(
						tabPanel("Total calories", verbatimTextOutput("RMR"))
						),
			h3('Calculation 2: Calories need per body weight'), hr(),
			selectInput("outcome", label = h4("Please select desired outcome: "), c("Lose weight" = 1 ,"Maintain weight" = 2, "Gain weight" = 3), selected = 2),
      
			tabsetPanel(
				tabPanel("Total calories", 
						#h5('#minimum - maximum of total calories:'),verbatimTextOutput("calneed"), 
						showOutput("chartTotal","highcharts")
						),
				tabPanel("Calories breakdown in macronutrients", 
						#h5('#calories from carbohydrate:'), verbatimTextOutput("macroCarb"),
						#h5('#calories from fat:'), verbatimTextOutput("macroFat"),
						#h5('#calories from protein:'), verbatimTextOutput("macroProt"),
						#verbatimTextOutput("daty")
						showOutput("chartCal","highcharts")
						), 
				tabPanel("Macronutrients breakdown in grams", 
						#h5('#grams of carbohydrate:'), verbatimTextOutput("macroGCarb"),
						#h5('#grams of fat:'), verbatimTextOutput("macroGFat"),
						#h5('#grams of protein:'), verbatimTextOutput("macroGProt"),
						showOutput("chartGram","highcharts")
						)
				)
    
		)
	)

 ))
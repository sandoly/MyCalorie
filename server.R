library(shiny)
library(rCharts)

shinyServer(
  function(input, output) {
	
	ACTIVITY_MPY <- reactive ( switch (as.numeric(input$activity), "0" = 1, "1" = 1.2, "2" = 1.375, "3" = 1.55, "4" = 1.725, "5" = 1.9)
	
					)
	RMR <- reactive(	if (as.character(input$gender)== "Male")
						{ (9.99 * as.numeric(input$weight) + 6.25 * as.numeric(input$height) - 4.92 * as.numeric(input$age) + 5) * ACTIVITY_MPY() }
						else if (as.character(input$gender)== "Female")
						{(9.99 * as.numeric(input$weight) + 6.25 * as.numeric(input$height) - 4.92 * as.numeric(input$age) - 161) * ACTIVITY_MPY()} 
					)
						
	CALNEED <- reactive (	
						switch (as.numeric(input$outcome), 	"1" = { c(as.numeric(input$weight) * 20, as.numeric(input$weight) * 25)} , 	#lose weight 20-25 calories per kg body weight
															"2" = { c(as.numeric(input$weight) * 25, as.numeric(input$weight) * 30)} , 	#maintain weight 25-30 calories per kg body weight
															"3"	= { c(as.numeric(input$weight) * 30, as.numeric(input$weight) * 35)}	#gain weight 30-35 calories per kg body weight
								)
						)
	MACRONEED <- reactive 	(	if (as.numeric(input$age) < 4) 	{ c( CALNEED() * 	0.55, CALNEED() * 0.35, CALNEED() *	0.1) 
								#sample macronutrients breakdown for Children, 1-3 years: 55% calories from carbs - 35% calories from fat - 10% calories from protein 
																}
								else if (as.numeric(input$age) > 3 &&  as.numeric(input$age) < 18) 	{	c( CALNEED() * 	0.55, CALNEED() * 0.29, CALNEED() *	0.16)		
								#sample macronutrients breakdown for Children, 4-18 years: 55% calories from carbs - 29% calories from fat - 16% calories from protein 
																									}
								else if (as.numeric(input$age) > 18 ) 	{ c( CALNEED() * 	0.55, CALNEED() * 0.27, CALNEED() *	0.18)								
								#sample macronutrients breakdown for  Adults > 18 years: 55% calories from carbs - 27% calories from fat - 18% calories from protein 
																		}
							)
	MACROGRAMS <- reactive 	(	c( MACRONEED()[1] /4, MACRONEED()[2] /4, MACRONEED()[3] /9, MACRONEED()[4] /9, MACRONEED()[5] /4, MACRONEED()[6] /4 )
							)
	
	

	output$weight 		<- renderText({input$weight})
    output$height 		<- renderText({input$height})
	output$age 	  		<- renderText({input$age})
	output$gender 		<- renderText({input$gender})
	output$RMR	  		<- renderText({RMR()})
	output$chartTotal <- renderChart	({  									
										h3 <- rCharts::Highcharts$new()
										h3$chart(type = "columnrange", inverted= "true")
										h3$title(text="Total daily calories intake range")
										h3$legend(symbolWidth = 30, enabled = 0)
										h3$xAxis(categories = list("Total"))
										h3$yAxis(title = list(text = "Calories ( Cal )"))
										h3$series(name= "Calories", data = list(CALNEED()[1:2]))
										h3$plotOptions(columnrange = list(dataLabels=list(enabled=1, format='{y} Cal')))
										h3$tooltip(valueSuffix= 'Cal')
										h3$set(dom = "chartTotal")
										return(h3)
								})
	output$chartCal <- renderChart	({  									
										h1 <- rCharts::Highcharts$new()
										h1$chart(type = "columnrange", inverted= "true")
										h1$title(text="Daily calories intake range")
										h1$legend(symbolWidth = 30, enabled= 0)
										h1$xAxis(categories = list("Carbohydrate", "Fat", "Protein"))
										h1$yAxis(title = list(text = "Calories ( Cal )"))
										h1$series(name= "Calories", data = list(MACRONEED()[1:2],MACRONEED()[3:4],MACRONEED()[5:6]))
										h1$plotOptions(columnrange = list(dataLabels=list(enabled=1, format='{y} Cal')))
										h1$tooltip(valueSuffix= 'Cal')
										h1$set(dom = "chartCal")
										return(h1)
								})
	output$chartGram <- renderChart	({  									
										h2 <- rCharts::Highcharts$new()
										h2$chart(type = "columnrange", inverted= "true")
										h2$title(text="Daily macronutrients intake range in grams")
										h2$legend(symbolWidth = 30, enabled= 0)
										h2$xAxis(categories = list("Carbohydrate", "Fat", "Protein"))
										h2$yAxis(title = list(text = "grams"))
										h2$series(name= "Calories", data = list(MACROGRAMS()[1:2],MACROGRAMS()[3:4],MACROGRAMS()[5:6]))
										h2$plotOptions(columnrange = list(dataLabels=list(enabled=1, format='{y} grams')))
										h2$tooltip(valueSuffix= 'g')
										h2$set(dom = "chartGram")
										return(h2)
								})	
  }
)
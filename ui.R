library(shiny)

shinyUI(fluidPage(

  titlePanel("MPG Predictor: How Far Will Your Car Go on a Gallon?"),

  tabsetPanel(

    # ---- Tab 1: the app ----
    tabPanel("App",
      sidebarLayout(
        sidebarPanel(
          h4("Describe your car"),
          sliderInput("wt", "Weight (1000 lbs):",
                      min = 1.5, max = 5.5, value = 3, step = 0.1),
          sliderInput("hp", "Horsepower:",
                      min = 50, max = 340, value = 120, step = 5),
          radioButtons("am", "Transmission:",
                       choices = c("Automatic", "Manual"),
                       selected = "Automatic"),
          radioButtons("level", "Prediction interval:",
                       choices = c("80%" = 80, "90%" = 90, "95%" = 95),
                       selected = 95, inline = TRUE),
          checkboxInput("showline", "Show regression line on plot", value = TRUE),
          helpText("Move the sliders and the prediction updates automatically.")
        ),
        mainPanel(
          h3("Your predicted fuel economy"),
          h2(textOutput("pred_mpg")),
          textOutput("pred_interval"),
          textOutput("pred_l100"),
          br(),
          plotOutput("mpgPlot"),
          textOutput("model_r2")
        )
      )
    ),

    # ---- Tab 2: documentation (required to be on the Shiny site itself) ----
    tabPanel("How to use this app",
      h3("What does this app do?"),
      p("This app predicts a car's fuel economy in miles per gallon (MPG) from its
        weight, horsepower, and transmission type. It uses a linear regression model
        fit to the built-in", code("mtcars"), "dataset (1974 Motor Trend road tests of 32 cars)."),
      h3("Getting started in 4 steps"),
      tags$ol(
        tags$li("Click the ", strong("App"), " tab."),
        tags$li("Use the ", strong("Weight"), " and ", strong("Horsepower"),
                " sliders to describe your car."),
        tags$li("Pick ", strong("Automatic"), " or ", strong("Manual"), " transmission."),
        tags$li("Read the predicted MPG at the top. The plot shows your car as a red
                 diamond among the 32 real cars.")
      ),
      h3("What do the outputs mean?"),
      tags$ul(
        tags$li(strong("Predicted MPG: "), "the model's best estimate for your car."),
        tags$li(strong("Prediction interval: "), "the range where a car like yours would
                 fall with the chosen probability (80, 90 or 95%). Wider = less certain."),
        tags$li(strong("L/100 km: "), "the same prediction in metric units."),
        tags$li(strong("R-squared: "), "how much of the variation in MPG the model explains.
                 Closer to 1 is better.")
      ),
      h3("Tips"),
      p("Heavier and more powerful cars use more fuel. Try dragging the weight slider
        from light to heavy and watch the prediction fall. Sliders stay within the range
        of the original data, because predictions outside it are unreliable.")
    )
  )
))

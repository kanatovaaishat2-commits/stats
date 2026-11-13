library(shiny)

data(mtcars)
mtcars$am_f <- factor(mtcars$am, levels = c(0, 1), labels = c("Automatic", "Manual"))

# Fit the model once when the app starts
fit <- lm(mpg ~ wt + hp + am_f, data = mtcars)

shinyServer(function(input, output) {

  # Build a one-row data frame from the user's inputs
  new_car <- reactive({
    data.frame(wt = input$wt,
               hp = input$hp,
               am_f = factor(input$am, levels = c("Automatic", "Manual")))
  })

  # Prediction with an interval at the chosen level
  prediction <- reactive({
    predict(fit, newdata = new_car(), interval = "prediction",
            level = as.numeric(input$level) / 100)
  })

  output$pred_mpg <- renderText({
    paste(round(prediction()[1, "fit"], 1), "miles per gallon")
  })

  output$pred_interval <- renderText({
    p <- prediction()
    paste0(input$level, "% prediction interval: ",
           round(p[1, "lwr"], 1), " to ", round(p[1, "upr"], 1), " MPG")
  })

  output$pred_l100 <- renderText({
    mpg <- max(prediction()[1, "fit"], 1)
    paste("That is about", round(235.215 / mpg, 1), "litres per 100 km")
  })

  output$model_r2 <- renderText({
    paste("Model R-squared:", round(summary(fit)$r.squared, 3))
  })

  output$mpgPlot <- renderPlot({
    cols <- ifelse(mtcars$am_f == "Automatic", "steelblue", "darkorange")
    plot(mtcars$wt, mtcars$mpg, pch = 19, col = cols, cex = 1.3,
         xlab = "Weight (1000 lbs)", ylab = "Miles per gallon",
         main = "Your car vs. the 32 cars in mtcars")

    if (input$showline) {
      grid_wt <- seq(1.5, 5.5, length.out = 50)
      line_df <- data.frame(wt = grid_wt, hp = input$hp,
                            am_f = factor(input$am, levels = c("Automatic", "Manual")))
      lines(grid_wt, predict(fit, line_df), lwd = 2, lty = 2)
    }

    points(input$wt, prediction()[1, "fit"], pch = 18, col = "red", cex = 3)
    legend("topright", pch = c(19, 19, 18), col = c("steelblue", "darkorange", "red"),
           legend = c("Automatic", "Manual", "Your car"), bty = "n")
  })
})

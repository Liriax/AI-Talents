#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
PYTHON_DEPENDENCIES = c('pandas','numpy','scikit-learn', 'category_encoders')
df<-read.csv('test.csv',encoding="ISO-8859-1")
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("TechSkillytics"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("skills",
                        "Number of skills:",
                        min = 1,
                        max = 30,
                        value = 10),
      

        selectInput("job", 
                    label = "Choose a Job Title",
                    choices = c("software engineer", 
                                "project manager"),
                    selected = "software engineer"),
        textInput("current_skills", 
                    "Your current skills:")
        ),
        
        
        mainPanel(
          plotOutput("skillPlot"), 
          textOutput("predicted_job")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  python_path = Sys.getenv('PYTHON_PATH')
  
  # Create virtual env and install dependencies
  reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES)
  reticulate::use_virtualenv(virtualenv_dir, required = T)
  reticulate::source_python('slide.py')
  
    output$skillPlot <- renderPlot({
      getNTopSkillsFromJob(df, input$job, input$skills)
      data <-read.csv('result.csv',encoding="ISO-8859-1")
      
      # Render a barplot
      barplot(height=data$frequency, names=data$skills,
              main=paste("Top skills for", input$job),
              ylab="Frequency in Percent",
              xlab="Skills")
    })
    output$predicted_job <- renderText({
      paste("Predicted job title based on current skills: ", predict_res(input$current_skills))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)






library(shiny)
library(wordcloud)
PYTHON_DEPENDENCIES = c('pandas','numpy','scikit-learn', 'category_encoders')
df<-read.csv('test.csv',encoding="ISO-8859-1")

company_df = data.frame(employee=c("Alice"), position=c("data analyst"), skills=c("sql, R"))

# UI design ----------------------------------------------------------------
ui <- navbarPage("TechSkillytics",

# 1. Slide 
  tabPanel("1. Slide",
    # 1. Slide title
    titlePanel("First Slide"),
           
    # Sidebar with a slider input for number of skills 
    sidebarLayout(
        sidebarPanel(
            sliderInput("skills",
                        "Number of skills:",
                        min = 1,
                        max = 30,
                        value = 10),
            textInput("current_job", 
                      "Enter your current job title"),

            selectInput("job",
                        label = "Or choose a Job Title",
                        choices = c("software engineer",
                                    "project manager","database administrator",
                                    "big data engineer", "data analyst",
                                    "business intelligence analyst","java developer",
                                    "information security analyst","security architect","network engineer",
                                    "IT support","application developer","information systems coordinater",
                                    "database administrator","web developer","cloud engineer","DevOps engineer",
                                    "UX designer", "quality assurance engineer","hardware engineer"),
                        selected = "software engineer"),
                 
            textInput("current_skills", 
                        "Enter your current skills (separated by comma)")
        
        
        ),
        
        
        mainPanel(
          plotOutput("skillPlot"), 
          textOutput("predicted_job"),
          textOutput("skill_gap"),
          plotOutput("skillTime")
          
          
        )
    )
  ),
# 2. Slide 
 tabPanel("2. Slide",
   fluidPage(
     titlePanel(title = "Adding employee profiles"), 
     sidebarLayout(
       
       sidebarPanel(textInput("employee_name","Enter employee name"),
                    br(),
                    textInput("employee_skills","Enter employee skills"),
                    br(),
                    textInput("employee_position","Enter employee position"),
                    actionButton("add_btn", "Add"),
                    br(),
                    textInput("training","Enter the skills that you plan to train")
                    ),
       mainPanel(
         plotOutput("teamSkills"),
         
         DT::dataTableOutput("table")
         
       )
       
     )
   )
 ),

# 3. Slide 
 tabPanel("3. Slide", "Also blank")
)

# Define server logic ------------------------------------------------------------
server <- function(input, output) {
  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  python_path = Sys.getenv('PYTHON_PATH')
  
  # Create virtual env and install dependencies
  reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES)
  reticulate::use_virtualenv(virtualenv_dir, required = T)
  reticulate::source_python('slide.py')
  
    findJob <- reactive({findSimilarJobTitle(input$current_job)})

    output$skillPlot <- renderPlot({
      job <- findJob()
      if (job==""){job<-input$job}
      getNTopSkillsFromJob(df, job, input$skills)
      data <-read.csv('result.csv',encoding="ISO-8859-1")
      
      # Render a bar plot
      barplot(height=data$frequency, names=data$skills,
              main=paste("Top skills for", job),col=rgb(1, 0.8, 0.8, 0.8),
              ylab="Frequency in Percent",
              xlab="Skills")
    })
    
    output$predicted_job <- renderText({
      paste("Predicted job title based on current skills: ", predict_res(input$current_skills))
    })
    
    output$skill_gap <- renderText({
      job <- findJob()
      if (job==""){job<-input$job}
      paste("Your skill gaps are: ", findSkillGap(df, job, input$current_skills, input$skills))
    })
    
    output$skillTime <- renderPlot({
      job <- findJob()
      if (job==""){job<-input$job}
      getSkillGapList(df, job, input$current_skills, input$skills)
      data <-read.csv('result2.csv',encoding="ISO-8859-1")
      # Render a bar plot
      barplot(height=data$time, names=data$skill,horiz=TRUE,col=rgb(0, 0.8, 0.8, 0.8),
              main="Learning Time",
              xlab="hours")
    })
    
    values <- reactiveValues()
    values$df <- company_df
    observeEvent(input$add_btn, {
      newLine <- isolate(c(input$employee_name, input$employee_position, input$employee_skills))
      isolate(values$df <- rbind(values$df, newLine))
    })
    output$table <- DT::renderDataTable(values$df, editable="all")
    # output$teamSkills <- renderPlot({
    #   v <- values$df
    #   data <- getSkillFreqDict(v,"skills")
    #   barplot(height=data$frequency, names=data$skills,horiz=TRUE,col=rgb(0, 0.8, 0.8, 0.8))
    # })
}

# Run the application ---------------------------------------
shinyApp(ui = ui, server = server)

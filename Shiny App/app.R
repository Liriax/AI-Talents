


library(shiny)
library(wordcloud2)
library(dplyr)  
library(ggplot2)  
library(tidyverse)
PYTHON_DEPENDENCIES = c('pandas','numpy','scikit-learn', 'category_encoders')
df<-read.csv('test.csv',encoding="ISO-8859-1")
sector_df <- read.csv('Sector_skills.csv')
company_df = data.frame(employee=c("Alice", "Bob", "Tim"), position=c("data analyst", "software engineer", "project manager"), skills=c("sql,r","java,c,javascript", "agile,linux,sap"))

# UI design ----------------------------------------------------------------
ui <- navbarPage("TechSkillytics",

    # 1. Slide UI ----------------------------------------------------------------- 
  tabPanel("For Individual",
    # 1. Slide title
    titlePanel("Individual Skill Analysis"),
           
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
          br(),
          textOutput("predicted_job"),
          br(),
          textOutput("skill_gap"),
          br(),
          plotOutput("skillTime")
          
          
        )
    )
  ),
 # tabPanel("2. Slide",
 #   fluidPage(
 #     titlePanel(title = "Adding employee profiles"), 
 #     sidebarLayout(
 #       
 #       sidebarPanel(textInput("employee_name","Enter employee name"),
 #                    br(),
 #                    textInput("employee_skills","Enter employee skills"),
 #                    br(),
 #                    textInput("employee_position","Enter employee position"),
 #                    actionButton("add_btn", "Add")
 #                    
 #                    ),
 #       mainPanel(
 #         
 #         
 #         DT::dataTableOutput("table"),
 #         plotOutput("selected")
 #       )
 #       
 #     )
 #   )
 # ),

    # 2. Slide UI -----------------------------------------------------------------
 tabPanel("For Company", #"Sector level analysis",
          fluidPage(
            h4("Your sector's wanted skills"), 
            wordcloud2Output('sectorplot'),
            
            hr(),
            
            fluidRow(
              column(4,
                     textInput('company_name', 'Company name'),
                     selectInput('company_sector', 'Company sector', c(sector_df$Sector))
              ),
              column(4,
                     selectInput('company_size', 'Company size', c("All","Small", "Medium Small",
                                                                   "Medium Large", "Large")),
                     h5("Small: 1-200 Employees"),h5("Medium Small: 201-1000 Employees"),
                     h5("Medium Large: 1001-10000 Employees"), h5("Large: more than 10000 Employees")
                     
              ),
              column(4,
                     textInput("training","Enter the skill that you plan to train"),
                     textOutput("training_effect")
                     
              )
            ),
            hr(),
            h4("Your Team's Skill Pool"),
            
            wordcloud2Output("teamSkills"),
            
            fluidRow(
              column(5,
                     h4("Add employee profiles"),
                     wellPanel(textInput("employee_name","Enter employee name"),
                                  br(),
                                  textInput("employee_skills","Enter employee skills (separate by comma)"),
                                  br(),
                                  textInput("employee_position","Enter employee position"),
                                  actionButton("add_btn", "Add")
                                  ),
                      DT::dataTableOutput("table")
                                  
              ),
              column(7,
                     
                     plotOutput("team_gap")
                     
              )
            )
            
            
            
          )
      )
)

# Define server logic ------------------------------------------------------------
server <- function(input, output) {
    # Virtualenv settings --------------------------------------------------------
  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  python_path = Sys.getenv('PYTHON_PATH')
  
  
  # Create virtual env and install dependencies
  reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES)
  reticulate::use_virtualenv(virtualenv_dir, required = T)
  reticulate::source_python('slide.py')

    # wordcloud2a --------------------
  wordcloud2a <- function (data, size = 1, minSize = 0, gridSize = 0, fontFamily = "Segoe UI", 
                           fontWeight = "bold", color = "random-dark", backgroundColor = "white", 
                           minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE, 
                           rotateRatio = 0.4, shape = "circle", ellipticity = 0.65, 
                           widgetsize = NULL, figPath = NULL, hoverFunction = NULL) 
  {
    if ("table" %in% class(data)) {
      dataOut = data.frame(name = names(data), freq = as.vector(data))
    }
    else {
      data = as.data.frame(data)
      dataOut = data[, 1:2]
      names(dataOut) = c("name", "freq")
    }
    if (!is.null(figPath)) {
      if (!file.exists(figPath)) {
        stop("cannot find fig in the figPath")
      }
      spPath = strsplit(figPath, "\\.")[[1]]
      len = length(spPath)
      figClass = spPath[len]
      if (!figClass %in% c("jpeg", "jpg", "png", "bmp", "gif")) {
        stop("file should be a jpeg, jpg, png, bmp or gif file!")
      }
      base64 = base64enc::base64encode(figPath)
      base64 = paste0("data:image/", figClass, ";base64,", 
                      base64)
    }
    else {
      base64 = NULL
    }
    weightFactor = size * 180/max(dataOut$freq)
    settings <- list(word = dataOut$name, freq = dataOut$freq, 
                     fontFamily = fontFamily, fontWeight = fontWeight, color = color, 
                     minSize = minSize, weightFactor = weightFactor, backgroundColor = backgroundColor, 
                     gridSize = gridSize, minRotation = minRotation, maxRotation = maxRotation, 
                     shuffle = shuffle, rotateRatio = rotateRatio, shape = shape, 
                     ellipticity = ellipticity, figBase64 = base64, hover = htmlwidgets::JS(hoverFunction))
    chart = htmlwidgets::createWidget("wordcloud2", settings, 
                                      width = widgetsize[1], height = widgetsize[2], sizingPolicy = htmlwidgets::sizingPolicy(viewer.padding = 0, 
                                                                                                                              browser.padding = 0, browser.fill = TRUE))
    chart
  }
    # 1. Slide SL -------------------------------------------------------------------
    findJob <- reactive({findSimilarJobTitle(input$current_job)})
    # Render a bar plot that shows top skills for a given job title
  
    output$skillPlot <- renderPlot({
      job <- findJob()
      if (job==""){job<-input$job}
      getNTopSkillsFromJob(df, job, input$skills)
      data <-read.csv('result.csv',encoding="ISO-8859-1")
      
      barplot(height=data$frequency, names=data$skills,
              main=paste("Top skills for", job),col=rgb(1, 0.8, 0.8, 0.8),
              ylab="Frequency in Percent")
    })
    
    output$predicted_job <- renderText({
      paste("Predicted job title based on current skills: ", predict_res(input$current_skills))
    })
    
    output$skill_gap <- renderText({
      job <- findJob()
      if (job==""){job<-input$job}
      paste("Your skill gaps are: ", findSkillGap(df, job, input$current_skills, input$skills))
    })
    
    # Render a bar plot that shows learning time for the person
    
    output$skillTime <- renderPlot({
      job <- findJob()
      if (job==""){job<-input$job}
      getSkillGapList(df, job, input$current_skills, input$skills)
      data <-read.csv('result2.csv',encoding="ISO-8859-1")
      # Render a bar plot
      # barplot(height=data$time, names=data$skill,horiz=TRUE,col=rgb(0, 0.8, 0.8, 0.8),
      #         main="Learning Time",
      #         xlab="hours")
      ggplot(data, aes(x=skill, y=time))+geom_bar(stat='identity', fill="bisque1")+coord_flip()+labs(x = "", y="hour",title = "Skill Gaps Learning Time")+theme_bw()
      
    })
    # 2. Slide SL -------------------------------------------------------------------
    
    values <- reactiveValues()
    values$df <- company_df
    observeEvent(input$add_btn, {
      newLine <- isolate(c(input$employee_name, input$employee_position, input$employee_skills))
      isolate(values$df <- rbind(values$df, newLine))
    })
    output$table <- DT::renderDataTable(values$df)
    selected_employee <- reactive({
      values$df[input$table_rows_selected, ]
    })
    
    # output$selected <- renderPlot({
    #   s <- selected_employee()
    #   if (nrow(s)==1){
    #     job <- findSimilarJobTitle(s$position)
    #     getNTopSkillsFromJob(df, job, 10)
    #     data <-read.csv('result.csv',encoding="ISO-8859-1")
    #     
    #     # Render a bar plot
    #     barplot(height=data$frequency, names=data$skills,
    #             main=paste("Top 10 skills for", job),col=rgb(1, 0.8, 0.8, 0.8),
    #             ylab="Frequency in Percent")
    #   }
    # })
    
    
    #options(bitmapType='cairo')
    
    output$sectorplot <- renderWordcloud2({
      if (input$company_size != "All"){
        chosen_sector_skills <- sector_df[sector_df$Sector==input$company_sector &
                                            sector_df$Size==input$company_size, "All_skills"]
      } else{
        chosen_sector_skills <- sector_df[sector_df$Sector==input$company_sector, "All_skills"]
        
      }
       # First: tokenize the data
      text_tokens <- scan(text = chosen_sector_skills,
                          what = "character",
                          quote = "",
                          sep = ",")
      
      # Second: make frequency tables
      freq_text <- table(text_tokens)%>% 
        sort(decreasing = T) %>% 
        as.data.frame()
      
      # Third: make wordcloud
      wordcloud2a(freq_text,
                 color = "random-light")
    })
    
    output$teamSkills <- renderWordcloud2({
      if (nrow(selected_employee())==0){
        v <- values$df
      } else {
        v <- selected_employee()
      }
      text_tokens <- scan(text = v[["skills"]],
                          what = "character",
                          quote = "",
                          sep = ",")
      
      freq_text <- table(text_tokens)%>% sort(decreasing = T) %>% as.data.frame()
      
      wordcloud2a(freq_text, size=0.5)
    })
    
    output$training_effect <- renderText({
      if (nrow(selected_employee())==0){
        v <- values$df
      } 
      else{
        v <- selected_employee()
      }
      total_n = nrow(v)
      text_tokens <- scan(text = v[["skills"]],
                          what = "character",
                          quote = "",
                          sep = ",")
      freq_text <- table(text_tokens) %>% as.data.frame()
      skilled_n = freq_text[str_trim(freq_text$text_tokens)==input$training,"Freq"]
      paste(skilled_n, " out of ",total_n, " of your team already have this skill")
    })
    
    output$team_gap <- renderPlot({
      if (nrow(selected_employee())==1){
      } else{
        if (nrow(selected_employee())==0){
          v <- values$df
        } 
        else{
          v <- selected_employee()
        }
        text_tokens <- getTeamSkillGap(df, v, input$skills)
        freq_text <- table(text_tokens)%>% sort(decreasing = T) %>% as.data.frame()
        
        # Render a bar plot
        ggplot(freq_text, aes(text_tokens, Freq))+geom_col(fill="#69b3a2")+theme_bw()+labs(title = "Team Skill Gaps")+theme(axis.title.x=element_blank(),axis.title.y=element_blank())
      }
      })
   
    
}

# Run the application ---------------------------------------
shinyApp(ui = ui, server = server)

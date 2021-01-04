


library(shiny)
library(wordcloud2)
library(dplyr)  
library(ggplot2)  
library(tidyverse)
library(shinydashboard)
library(stringr)
library(png)
library(shinyjs)
library(DT)
library(visNetwork)
library(rintrojs)


PYTHON_DEPENDENCIES = c('pandas','numpy==1.19.3','scikit-learn', 'category_encoders','joblib')
df<-read.csv('test.csv',encoding="ISO-8859-1")
sector_df <- read.csv('Sector_skills.csv')
company_df = data.frame(employee=c("Lauren Ipsum", "Tim Friedmann", "Stefan Meyer", "Adam Smith"), position=c("data analyst", "software engineer", "project manager", "business intelligence analyst"), skills=c("sql,r, tableau, statistics, python","java,c,javascript, python", "agile,linux,sap, r, python", "economics, finance, r, c#"))


# Trying something out -----------------------------



# sidebar<-dashboardSidebar(
#   sidebarMenu(
#     menuItem("Individual", tabName = "db1", icon = icon("dashboard"))
#     ,
#     menuItem("Company", tabName = "db2", icon = icon("dashboard"))
#   )
# )

sidebar<-sidebarPanel(
  # textInput('company_name', 'Company name'),
  selectInput('company_sector', 'Company sector', c(sector_df$Sector)),
  selectInput('company_size', 'Company size', c("All","Small", "Medium Small","Medium Large", "Large")),
  tags$p("Small: 1-200 Employees"),
  tags$p("Medium Small: 201-1000 Employees"),
  tags$p("Medium Large: 1001-10000 Employees"),
  tags$p("Large: more than 10000 Employees")
)

body <- mainPanel(
  # wordcloud2Output('sectorplot')
)
# body <- dashboardBody(
#   
#   tabItems(
    # tabItem(
    #   tabName = "db1",
    #   fluidRow(
    #     box(
    #       title = "Individual Skill Analysis",
    #       solidHeader = T,
    #       width = 3, 
    #       collapsible = T,
    #       collapsed = F,
    #       textInput("current_job","Enter your current job title"),
    #       selectInput("job",label = "Or choose a Job Title",
    #                   choices = c("software engineer",
    #                               "project manager","database administrator",
    #                               "big data engineer", "data analyst",
    #                               "business intelligence analyst","java developer",
    #                               "information security analyst","security architect","network engineer",
    #                               "IT support","application developer","information systems coordinater",
    #                               "database administrator","web developer","cloud engineer","DevOps engineer",
    #                               "UX designer", "quality assurance engineer","hardware engineer"),
    #                   selected = "software engineer"),
    #       
    #       textInput("current_skills","Enter your current skills (separated by comma)"),
    #       sliderInput("skills","Number of skills:",min = 1,max = 30,value = 10)
    #     ),
    #     
    #     
    #     box(
    #       title = "Job Position Information",
    #       br(),
    #       solidHeader = T,
    #       collapsible = T,
    #       width = 4,
    #       collapsed = F,
    #       #plotOutput("skillPlot")
    #       ),
    #     
    #     box(
    #       solidHeader = T,
    #       collapsible = T,
    #       collapsed = F,
    #       width = 5,
    #       title = "Skill Gap Analysis",
    #       h5(strong("Learning Time")),
    #       # plotOutput("skillTime")
    #     ),
    #     fluidRow(        
    #       # infoBoxOutput("predicted_job"),
    #       # infoBoxOutput("skill_gap"),
    #       # valueBoxOutput("value")
    #     ),
    #   )
    # )
    # ,
#     tabItem(
#       tabName = "db2",
#       fluidRow(
#         box(
#           title = "Company Profile",
#           solidHeader = T,
#           width = 2,
#           textInput('company_name', 'Company name'),
#           selectInput('company_sector', 'Company sector', c(sector_df$Sector)),
#           selectInput('company_size', 'Company size', c("All","Small", "Medium Small","Medium Large", "Large")),
#           tags$p("Small: 1-200 Employees"),
#           tags$p("Medium Small: 201-1000 Employees"),
#           tags$p("Medium Large: 1001-10000 Employees"),
#           tags$p("Large: more than 10000 Employees")
#         ),
#         box(
#           solidHeader = T,
#           width = 5,
#           h4("Your sector's wanted skills"), 
#           # wordcloud2Output('sectorplot')
#         ),
#         box(
#           solidHeader = T,
#           width = 5,
#           h4("Your Team's Skill Pool"),
#           # wordcloud2Output("teamSkills")
#         )
#       ),
#       fluidRow(
#         box(
#           title = "Workforce Profile",
#           solidHeader = T,
#           width = 3,
#           textInput("employee_name","Enter employee name"),
#           textInput("employee_skills","Enter employee skills (separate by comma)"),
#           textInput("employee_position","Enter employee position"),
#           actionButton("add_btn", "Add"),
#           textInput("training","Enter the skill that you plan to train"),
#           valueBoxOutput("training_effect")
#         ),
#         box(
#           title = "Workforce Data",
#           solidHeader = T,
#           width = 4,
#           hr(),
#           # DT::dataTableOutput("table")
#         ),
#         box(
#           title = "Team Skill Gap",
#           solidHeader = T,
#           width = 5,
#           # plotOutput("team_gap")
#         )
#       )
#     )
# 
#   )
#   
#   
# )




# UI design ----------------------------------------------------------------


# Panel div for visualization


panel_div <- function(class_type, content) {
  div(class = sprintf("panel panel-%s", class_type),
      div(class = "panel-body", content)
  )
}

ui <- navbarPage(title = img(src="TechHippo.png", height = "40px"), id = "navBar",
                   theme = "paper.css",
                   collapsible = TRUE,
                   inverse = TRUE,
                   windowTitle = "TechSkillytics",
                   position = "fixed-top",
                   footer = F,
                   header = tags$style(
                     ".navbar-right {
                       float: right !important;
                       }",
                     "body {padding-top: 75px;}"),
                   
                 
                 
                 #-----------------------------------
                 tabPanel("INPUT", value = "input",
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<br><br><center> <h1>Hello!</h1> </center><br>"),
                                   shiny::HTML("<h5> Your company has hired TechQuartier's new service, TechSkillytics.</h5> 
                                               <h5> Each member of your <i>(fictional)</i> team has received the questionnaire below via email, and your teammates have already responded and sent it to TechQuartier.</h5>
                                               <h5> Once the entire team finishes the questionnaire and send it to TechQuartier, you will receive an email with a link to the TechSkillytics app.</h5>
                                               <h5> Since you're the last one left, your results will be available as soon as you are complete! </h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            
                            style = "height:20px;"),
                          # 
                          # fluidRow(
                          #   column(3),
                          #   column(6,
                          #          textInput("current_job",""),
                          #          
                          #          )
                          # ),
                          
                          fluidRow(
                            
                            style = "height:20px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5>First, </h5>
                                               <h5> we would like you to chose a job title from the list below that best matches your current job.</h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   selectInput("job",label="",
                                               choices = c("software engineer",
                                                           "project manager","database administrator",
                                                           "big data engineer", "data analyst",
                                                           "business intelligence analyst","java developer",
                                                           "information security analyst","security architect","network engineer",
                                                           "IT support","application developer","information systems coordinater",
                                                           "database administrator","web developer","cloud engineer","DevOps engineer",
                                                           "UX designer", "quality assurance engineer","hardware engineer"),
                                               selected = "software engineer")
                                   )
                          ),
                          
                          fluidRow(
                            
                            style = "height:20px;"),
                          
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5> Now,</h5>
                                   <h5>   we need you to tell us what skills you possess, and believe are the most essential for the role you play in your team.</h5>
                                               <h5>Please write them in the line below, sepparating each skill with a comma ( , )</h5>")
                            ),
                            column(3)
                          ),
                          
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   textInput("current_skills","Prioritize skills which you believe sets you aside!"),
                                   
                            )
                          ),
                          
                          fluidRow(
                            
                            style = "height:20px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   sliderInput("skills","Number of skills:",min = 1,max = 30,value = 10)
                                   
                            )
                          ),
                          
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5> Thank you for sending us your skills!</h5>
                                   <h5>  Now you can check our analysis by clicking on the RESULTS tab.</h5>")
                            ),
                            column(3)
                          )
                          
                   
                   
                 ),
                 
                 #----------------------------------
                 
                   tabPanel("RESULTS", value = "results",
                            
                            shinyjs::useShinyjs(),
                            
                            tags$head(tags$script(HTML('
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName("a");
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute("data-value") == tabName) {
                                                       link.click();
                                                       };
                                                       }
                                                       };
                                                       '))),
                            fluidRow(
                              HTML("
                                     
                                     <section class='banner'>
                                     <h2 class='parallax'>TechSkillytics</h2>
                                     <p class='parallax_description'>Spot your skill gaps and dig out hidden talents with our AI skill analyst</p>
                                     </section>
                                     ")
                            ),
                            fluidRow(
                              
                              style = "height:200px;"),
                            
                            # WHAT
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1>Hello, again!</h1> </center><br>"),
                                     shiny::HTML("<h5>With the data that we have collected from you and your teammates,
                                                   we have assembled a summary of your skills and calculated potential skill gaps
                                                   your team may have.</h5>
                                                 <h5> We ran the data you gave us with the data we have gathered by analyzing job seeking websites, online course websites and others.</h5>
                                                 <h5> Ready to learn a little more about how your skills compare with the market?</h5>")
                              ),
                              column(3)
                            ),
                            
                            fluidRow(
                              
                              style = "height:300px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1> First,  </h1> </center><br>"),
                                     shiny::HTML("<h5> let's see the most wanted skills for your job position:  </h5>")
                              ),
                              column(3)
                            ),
                            #1
                            fluidRow(
                              column(3),
                              column(6,
                                     plotOutput("skillPlot")
                              ),
                              column(3)
                            ),
                            
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> And these are your skill gaps:  </h5>")
                              )
                            ),
                            #2
                            fluidRow(
                              column(3),
                              column(6,
                                     textOutput("skill_gap")
                              ),
                              column(3)
                            ),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> Which means you are this far away from the skill requirements:  </h5>")
                              )
                            ),
                            #3
                            fluidRow(
                              column(3),
                              column(6,
                                     valueBoxOutput("value")
                              ),
                              column(3)
                            ),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> Your skills actually match to this job title as well  </h5>")
                              )
                            ),
                            #4
                            fluidRow(
                              column(3),
                              column(6,
                                     textOutput("predicted_job")
                              ),
                              column(3)
                            ),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> And the learning time for your lacking skills is  </h5>")
                              )
                            ),
                            #5
                            fluidRow(
                              column(3),
                              column(6,
                                     plotOutput("skillTime")
                              ),
                              column(3)
                            ),
                            
                            
                            # The skills the team has
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1> Now,  </h1> </center><br>"),
                                     shiny::HTML("<h5> let's see the skills your team members told us they already have. According to our survey, these are the skills that your team posseses:  </h5>")
                              ),
                              column(3)
                            ),
            
                            
                            fluidRow(
                              
                              style = "height:50px;"),
                            #6
                            fluidRow(
                              column(3),
                              column(6,
                                DT::dataTableOutput("table")
                              )),
                            
                            fluidRow(
                              
                              style = "height:50px;"),
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> And this is how the skill pool of your team looks like:  </h5>")
                              ),
                              column(3)
                            ),
                           
                            #7
                            fluidRow(
                              column(3),
                              column(6,
                                     wordcloud2Output("teamSkills")
                              )),
                            
                            fluidRow(
                              
                              style = "height:50px;"),
                            
                            
                            #8
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> According to our calculations, these are the skill gaps in your team:  </h5>")
                              ),
                              column(3)
                            ),
                            
                            fluidRow(
                              
                              style = "height:50px;"),
                            
                            fluidRow(
                              column(3),
                              column(6,
                                plotOutput("team_gap"))
                              ),
                            
                            fluidRow(
                              
                              style = "height:300px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                            
                            # fluidRow(
                            #   column(3),
                            #   column(6,
                            #          shiny::HTML("<br><br><center> <h1> Now...  </h1> </center><br>"),
                            #          shiny::HTML("<h5> let's see what is expected in the market for the position you are in:  </h5>")
                            #   ),
                            #   column(3)
                            # ),
                            # 
                            # fluidRow(
                            #   
                            #   style = "height:300px;"),
                            
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1> How about...  </h1> </center><br>"),
                                     shiny::HTML("<h5>  We check how the scene is for companies like the one you work in?  </h5>")
                              ),
                              column(3)
                            ),
                        
                            #9
                            fluidRow(
                              column(3),
                              column(6,
                                     wordcloud2Output("sectorplot"))
                            ),

                            fluidRow(

                              style = "height:300px;"),
                            
                            
                            # fluidRow(
                            #   column(3),
                            #   column(6,
                            #          shiny::HTML("<br><br><center> <h1> According to our estimations...  </h1> </center><br>"),
                            #          shiny::HTML("<h5> to learn the skills your team misses, it would take roughly:  </h5>")
                            #   ),
                            #   column(3)
                            # ),
                            # 
                            # fluidRow(
                            #   
                            #   style = "height:300px;"),
                            
                            
                            # 10
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1> Thank you for using TechSkillytics!  </h1> </center><br>"),
                                     shiny::HTML("<h5> Now that you've seen what is expected in your field, you can also use our dashboard to explore what other areas are looking for in the market. Just click the \"Other sector's\" tab! </h5>")
                              ),
                              column(3)
                            ),
                            
                            fluidRow(
                              
                              style = "height:300px;"),
                           
                            # PAGE BREAK
                            tags$hr(),
                            
                       
                   ), # Closes the first tabPanel called "Home"
                 
                 
                 # -----------------------------------------------

                   tabPanel("Other sectors", value = "sectors",

                            sidebarLayout( sidebar, body )  # Closes the sidebarLayout
                   ),  # Closes the second tabPanel called "TechSkillytics"
                 
                 
                 #---------------------------------------------------------------
                   
                   tabPanel("ABOUT", value = "about",
                            
                            fluidRow(
                              shiny::HTML("<br><br><center> 
                                            <h1>About TechSkillytics</h1> 
                                            <h4>What's behind the data.</h4>
                                            </center>
                                            <br>
                                            <br>"),
                              style = "height:250px;"),
                            fluidRow(
                              column(2),
                              column(8,
                                     # Panel for Background on Data
                                     div(class="panel panel-default",
                                         div(class="panel-body",  
                                             tags$div( align = "center",
                                                       icon("bar-chart", class = "fa-4x"),
                                                       div( align = "center", 
                                                            h5("About the Data")
                                                       )
                                             ),
                                             tags$p(h6("We have obtained the data used in this program by webscraping job seeking websites, online course websites and others. As for the template, we have largely used the same template as the one used for career-pathfinder, which can be accessed at https://shiny.rstudio.com/gallery/career-pathfinder.html")),
                                             
                                         )
                                     ) # Closes div panel
                              ), # Closes column
                              column(2)
                            ),
                            # TEAM BIO
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h5>About the team</h5> </center><br>"),
                                     shiny::HTML("<h6>TechSkillytics is a project designed for the AiTalents Competition of 2020, as a possible product for TechQuartier by the team: T(AI)LENTS. Which is composed of: </h6>")
                              ),
                              column(3)
                            ),
                            
                            fluidRow(
                              
                              style = "height:50px;"),
                            
                            fluidRow(
                              column(3),
                              
                              # Joao Vitor
                              column(2,
                                     div(class="panel panel-default", 
                                         div(class="panel-body",  width = "600px",
                                             align = "center",
                                             div(
                                               tags$img(src = "Joao_c.png", 
                                                        width = "50px", height = "50px")
                                             ),
                                             div(
                                               tags$h5("Joao Vitor"),
                                               tags$h6( tags$i("From Brazil"))
                                             ),
                                             div(
                                               "Soon to graduate my masters in Business analytics from the Norwegian School Of Economics, NHH. I entered AI Talents because I thought it would be a great opportunity for me to expose myself to the field of data analytics, which I'm quite passionate about."
                                             )
                                         )
                                     )
                              ),
                              # Liria
                              column(2,
                                     div(class="panel panel-default",
                                         div(class="panel-body",  width = "600px", 
                                             align = "center",
                                             div(
                                               tags$img(src = "Liria_c.png", 
                                                        width = "50px", height = "50px")
                                             ),
                                             div(
                                               tags$h5("Xiaoge Zhang"),
                                               tags$h6( tags$i("aka Liria, from China"))
                                             ),
                                             div(
                                               "Studying Business Information Systems in TU Darmstadt, Germany. I entered the AI Talents programm to gain real data-driven product development experiences and challenge my programming skills."
                                             )
                                         )
                                     )
                              ),
                              # Sara 
                              column(2,
                                     div(class="panel panel-default",
                                         div(class="panel-body",  width = "600px", 
                                             align = "center",
                                             div(
                                               tags$img(src = "Sara_c.png", 
                                                        width = "50px", height = "50px")),
                                             div(
                                               tags$h5("Sara-Nel Ünal"),
                                               tags$h6( tags$i("From Germany and Turkey"))
                                             ),
                                             div(
                                               " Currently still in school but graduating this year. I entered the AI Talents program to challenge myself and explore my interests in the areas of Business and Data Science. "
                                             )
                                         )
                                     )
                              ),
                              column(3)
                              
                            ),
                            fluidRow(style = "height:150px;")
                   )  # Closes About tab
                   
)







# Define server logic ------------------------------------------------------------
server <- function(input, output) {
    # Virtualenv settings --------------------------------------------------------
  virtualenv_dir = Sys.getenv('VIRTUALENV_NAME')
  # python_path = Sys.getenv('PYTHON_PATH')
  # 
  # 
  # # Create virtual env and install dependencies
  # reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  # reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES)
  # reticulate::use_virtualenv(virtualenv_dir, required = T)
  # reticulate::source_python('slide.py')

    # (Ignore) wordcloud2a --------------------
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
    # DB2 SL -------------------------------------------------------------------

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
                 color = "random-light", size=0.3)
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

      wordcloud2a(freq_text, size=0.4)
    })

    output$training_effect <- renderValueBox({
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
      valueBox(skilled_n, paste(" out of ",total_n, " of your team already have this skill"))
    })

#     # Below are python codes----------------------------
# output$team_gap <- renderPlot({
#   if (nrow(selected_employee())==1){
#     job <- findSimilarJobTitle(selected_employee()$position)
#     # if (job==""){job<-input$job}
#     getNTopSkillsFromJob(df, job, input$skills)
#     data <-read.csv('result.csv',encoding="ISO-8859-1")
# 
#     # Render a bar plot that shows top skills for a given job title
# 
#     ggplot(data, aes(x=reorder(skills, -frequency), y=frequency))+geom_bar(stat="identity", fill = "indianred2")+labs(title = paste("Top skills for", job))+theme_bw()+
#       theme(axis.text.x = element_text(size = 15, angle = 45, vjust = 1, hjust=1))
# 
#   } else{
#     if (nrow(selected_employee())==0){
#       v <- values$df
#     }
#     else{
#       v <- selected_employee()
#     }
#     text_tokens <- getTeamSkillGap(df, v, input$skills)
#     freq_text <- table(text_tokens)%>% sort(decreasing = T) %>% as.data.frame()
# 
#     # Render a bar plot
#     ggplot(freq_text, aes(text_tokens, Freq))+
#       geom_col(fill="#69b3a2")+theme_bw()+labs(title = "Team Skill Gaps")+
#       theme(axis.title.x=element_blank(),axis.title.y=element_blank(),axis.text.x = element_text(size = 15,angle = 45, vjust = 1, hjust=1))
#   }
#   })

    # DB1 SL --------------------------------------------------------------------
    findJob <- reactive({findSimilarJobTitle(input$current_job)})

    output$predicted_job <- renderText({
      predict_res(input$current_skills)
    })


    output$skill_gap <- renderText({
      job <- findJob()
      if (job==""){job<-input$job}
      findSkillGap(df, job, input$current_skills, input$skills)
    })
    output$value <- renderValueBox({
      job <- findJob()
      if (job==""){job<-input$job}
      valueBox(paste(100 - findSkillGapPercentage(df, job, input$current_skills, input$skills),"%"), "Completion")
    })

    # Render a bar plot that shows top skills for a given job title

    output$skillPlot <- renderPlot({
      job <- findJob()
      if (job==""){job<-input$job}
      getNTopSkillsFromJob(df, job, input$skills)
      data <-read.csv('result.csv',encoding="ISO-8859-1")

      ggplot(data, aes(x=reorder(skills, -frequency), y=frequency))+geom_col(fill = "indianred2")+labs(title = paste("Top skills for", job))+theme_bw()+
        theme(axis.text.x = element_text(size = 15, angle = 45, vjust = 1, hjust=1))

      # barplot(height=data$frequency, names=data$skills,
      #         main=paste("Top skills for", job),col=rgb(1, 0.8, 0.8, 0.8),
      #         ylab="Frequency in Percent")

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
      ggplot(data, aes(x=reorder(skill, -time), y=time))+geom_bar(stat='identity', fill="royalblue2")+coord_flip()+labs(x = "", y="hour")+theme_bw()

    })

}

# Run the application ---------------------------------------
shinyApp(ui = ui, server = server)

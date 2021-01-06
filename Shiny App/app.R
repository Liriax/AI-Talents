

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


PYTHON_DEPENDENCIES = c('pandas','numpy','scikit-learn==0.22.2.post1', 'category_encoders','joblib')
df<-read.csv('test.csv',encoding="ISO-8859-1")
sector_df <- read.csv('Sector_skills.csv')

company_df2 = read.csv("HelloNow.csv")
company_df3 = read.csv("Equilibrium.csv")
# Predefined dataset for Software Giant
company_df = read.csv("Software_Giant.csv")
# company_df3 = 

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
  # ,
  # textInput("employee_name","Enter employee name"),
  # textInput("employee_skills","Enter employee skills (separate by comma)"),
  # textInput("employee_position","Enter employee position"),
  # actionButton("add_btn", "Add")
)

body <- mainPanel(
  # DT::renderDataTable("customize_table"),
 wordcloud2Output('sectorplot2')
)
# body <- dashboardBody(
#   
#  
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
                                   shiny::HTML("<h5>	&nbsp; Your company has hired TechQuartier's new service, TechSkillytics.</h5> 
                                               <h5> Each member of your (fictional) team has received the questionnaire below via email, and your teammates have already responded and sent it to TechQuartier.</h5>
                                               <h5> 	&nbsp; Once the entire team finishes the questionnaire and send it to TechQuartier, you will receive an email with a link to the TechSkillytics app.</h5>
                                               <h5>  Since you're the last one left, your results will be available as soon as you are complete! </h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            
                            style = "height:100px;"),
                         
                          fluidRow(
                            column(3),
                            column(6,
                                   align = "center",
                                   shiny::HTML("<h5> Enter your name: </h5>"),
                                   br(),
                                   textInput("name","")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            
                            style = "height:100px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5>  	&nbsp; First, </h5>
                                               <h5>	we would like you to chose a job title from the list below that best matches your current job.</h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   align = "center",
                                   
                                   br(),
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
                            
                            style = "height:100px;"),
                          
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5> 	&nbsp; Now,</h5>
                                   <h5>   we need you to tell us what skills you possess, and believe are the most essential for the role you play in your team.</h5>
                                               <h5>Please write them in the line below, sepparating each skill with a comma ( , )</h5>"),
                                   h6("You can select multiple members to form a smaller team or select a single row to see the top skills for that person's position.")
                            ),
                            column(3)
                          ),
                          
                
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   align = "center",
                                   
                                   br(),
                                   textInput("current_skills","Prioritize skills which you believe sets you aside!"),
                                   
                            )
                          ),
                          
                          fluidRow(
                            
                            style = "height:100px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   align = "center",
                                   
                                   sliderInput("skills","Number of skills to be displayed in the results",min = 1,max = 30,value = 10)
                                   
                            )
                          ),
                          
                          fluidRow(
                            
                            style = "height:100px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5>Which company do you work for?</h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   align = "center",
                                   
                                   selectInput("company",label="",
                                               choices = c("Software Giant", "HelloNow", "Equilibrium" ),
                                               selected = "Software Giant"),
                                   h6("Software Giant is a small company in the Information Technology sector"),
                                   h6("HelloNow is a medium-small company in the Business Services sector"),
                                   h6("Equilibrium is a large company in the Finance sector")
                                   
                            )
                          ),
                          fluidRow(
                            
                            style = "height:100px;"),
                          
                          fluidRow(
                            column(3),
                            column(6,
                                   shiny::HTML("<h5> Thank you for sending us your skills!</h5>
                                   <h5>  Now you can check our analysis by clicking on the RESULTS button</h5>")
                            ),
                            column(3)
                          ),
                          
                          fluidRow(
                            
                            style = "height:200px;")
                          
                          
                          
                          
                 ,
                 fluidRow(
                   column(3),
                   column(6,
                          tags$div(align = "center", 
                                   tags$a("RESULTS", 
                                          onclick="fakeClick('results')", 
                                          class="btn btn-primary btn-lg")
                          )
                   ),
                   column(3)
                 ),
                 fluidRow(style = "height:25px;"
                 )),
                 
                 #----------------------------------
                 
                   tabPanel("RESULTS", value = "results",
                            
                            
                            
                            shinyjs::useShinyjs(),
                            
                            tags$script(" $(document).ready(function () {
                             $('#inTabset a[data-toggle=\"tab\"]').bind('click', function (e) {
                                   $(document).load().scrollTop(0);
                                   });
                    
                                   });"),
                            
                            tags$head(tags$script(HTML("
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName('a');
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute('data-value') == tabName) {
                                                       link.click();
                                                       $('html, body').animate({ scrollTop: 0 }, 'fast');
                                                       };
                                                       }
                                                       };"
                                                       ))),
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
                                     shiny::HTML("<h5> let's see the most wanted skills for your job position...  </h5>")
                              ),
                              column(3)
                            ),
                            
                            
                            fluidRow(
                              
                              style = "height:300px;"),
                            
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> These are the frequency of the skills we found being demanded for you position on the job market: </h5>")
                              )
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
                              
                              style = "height:300px;"),
                            
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> This means that you may want to work on the following skills:  </h5>")
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
                              
                              style = "height:100px;"),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> If you had all of those, you'd have a perfect skillset! Right now, this is how complete your skill set is:   </h5>")
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
                              
                              style = "height:100px;"),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> According to our calculations, your skillset would be perfect for this position:  </h5>")
                              )
                            ),
                            #4
                            fluidRow(
                              column(3),
                              column(6,
                                     textOutput("predicted_job"),
                                     
                                     
                                     fluidRow(
                                       
                                       style = "height:300px;")
                              ),
                              column(3)
                            ),
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> This is the amount of hours you would need to invest in order to train the skills you are lacking:  </h5>")
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
                                     shiny::HTML("<h5> &nbsp;  let's see the skills your team members told us they already have. According to our survey, these are the skills that your team posseses:  </h5>")
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
                              
                              style = "height:300px;"),
                            
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
                            
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<h5> Wonder how many team members have a certain skill?  </h5>")
                              ),
                              column(3)
                            ),
                            
                            #10
                            fluidRow(
                              column(3),
                              column(6,
                                     align = "center",
                                     br(),
                                     textInput("training","Enter the skill"),
                                     valueBoxOutput("training_effect")
                              ),
                              column(3)
                            ),
                            fluidRow(style = "height:300px;"
                            ),
                            #11
                            fluidRow(
                              column(3),
                              column(6,
                                     shiny::HTML("<br><br><center> <h1> Thank you for using TechSkillytics!  </h1> </center><br>"),
                                     shiny::HTML("<h5>  &nbsp; Now that you've seen what is expected in your field, you can also use our dashboard to explore what other areas are looking for in the market. Just click the \"Other sectors\" tab! Or perhaps you will prefer to change your inputs in the \"INPUT\" tab! </h5>
                                     <h5> </h5>
                                                 <h5>  &nbsp; This is just the demo of what the app can do. In the future we would like to implement more features, like an analysis of what social media thinks of your skills/position and relay more interative information between team members easing the information transer between your team members! ")
                              ),
                              column(3)
                            ),
                            
                            fluidRow(
                              
                              style = "height:25px;"),
                            
                            # PAGE BREAK
                            tags$hr(),
                            
                       
                   ), # Closes the first tabPanel called "Home"
                 
                 
                 # -----------------------------------------------

                   tabPanel("All Sectors", value = "sectors",

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
                                             tags$p(h6(" We have obtained the data used in this program by web scraping job seeking websites (such as Glassdoor, and Dice), online course websites (such as Edx), and others to help us model industry sectors and define the skills (like a dataset from Linkedin, found on Kaggle). We used python to scrape the data with selenium, and R to clean the data for use.  As for the template for the app, we developed it in Rstudio using Shiny, and have largely relied on the same template as the one used for career-pathfinder, which can be accessed at the Shiny gallery ")),
                                             
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
                                               tags$h5("Sara-Nel Uenal"),
                                               tags$h6( tags$i("From Germany and Turkey"))
                                             ),
                                             div(
                                               " Currently still in high school but graduating this year. I entered the AI Talents program to challenge myself and explore my interests in the areas of Business and Data Science. "
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
  python_path = Sys.getenv('PYTHON_PATH')
  # 
  # # # Create virtual env and install dependencies
  # reticulate::virtualenv_create(envname = virtualenv_dir, python = python_path)
  # reticulate::virtualenv_install(virtualenv_dir, packages = PYTHON_DEPENDENCIES)
  reticulate::use_virtualenv(virtualenv_dir, required = T)
  reticulate::source_python('slide.py')

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

    # SL ---------------------------------------------------------------------
    
    # findJob <- reactive({findSimilarJobTitle(input$current_job)})
    
    get_company <- reactive({
      # job <- findJob()
      job<-input$job
      name<-input$name
      newLine <- c(name, job, input$current_skills)
      if(input$company=="Software Giant"){
        company<-rbind(company_df, newLine)
      }else if(input$company=="Equilibrium"){
        company<-rbind(company_df3, newLine)
      }else{company<-rbind(company_df2, newLine)}
    })
  
    #4
    output$predicted_job <- renderText({
      predict_res(input$current_skills)
    })

    #6
    output$table <- DT::renderDataTable({
      # job <- findJob()
      job<-input$job
      name <-input$name
      newLine <- c(name, job, input$current_skills)
      get_company()
    })

    #2
    output$skill_gap <- renderText({
      # job <- findJob()
      job<-input$job
      findSkillGap(df, job, input$current_skills, input$skills)
    })
    #3
    output$value <- renderValueBox({
      # job <- findJob()
      job<-input$job
      valueBox(paste(100 - findSkillGapPercentage(df, job, input$current_skills, input$skills),"%"), "Completion")
    })

    # Render a bar plot that shows top skills for a given job title
    #1
    output$skillPlot <- renderPlot({
      # job <- findJob()
      job<-input$job
      getNTopSkillsFromJob(df, job, input$skills)
      data <-read.csv('result.csv',encoding="ISO-8859-1")

      ggplot(data, aes(x=reorder(skills, -frequency), y=frequency))+geom_col(fill = "indianred2")+labs(x = "", title = paste("Top skills for", job))+theme_bw()+
        theme(axis.text.x = element_text(size = 15, angle = 45, vjust = 1, hjust=1))


    })

    # Render a bar plot that shows learning time for the person
    #5
    output$skillTime <- renderPlot({
      # job <- findJob()
      job<-input$job
      getSkillGapList(df, job, input$current_skills, input$skills)
      data <-read.csv('result2.csv',encoding="ISO-8859-1")
      # Render a bar plot
      # barplot(height=data$time, names=data$skill,horiz=TRUE,col=rgb(0, 0.8, 0.8, 0.8),
      #         main="Learning Time",
      #         xlab="hours")
      ggplot(data, aes(x=reorder(skill, -time), y=time))+geom_bar(stat='identity', fill="royalblue2")+coord_flip()+labs(x = "", y="hour")+theme_bw()

    })

    
    
    
    selected_employee <- reactive({
      get_company()[input$table_rows_selected, ]
    })
    
    #7
    output$teamSkills <- renderWordcloud2({
      if (nrow(selected_employee())==0){
        v <- get_company()
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
    
    #8
    output$team_gap <- renderPlot({
      if (nrow(selected_employee())==1){
        job <- findSimilarJobTitle(selected_employee()$position)
        if (job==""){job<-input$job}
        getNTopSkillsFromJob(df, job, input$skills)
        data <-read.csv('result.csv',encoding="ISO-8859-1")
        
        # Render a bar plot that shows top skills for a given job title
        
        ggplot(data, aes(x=reorder(skills, -frequency), y=frequency))+geom_bar(stat="identity", fill = "indianred2")+labs(x = "",title = paste("Top skills for", job))+theme_bw()+
          theme(axis.text.x = element_text(size = 15, angle = 45, vjust = 1, hjust=1))
        
      } else{
        if (nrow(selected_employee())==0){
          v <- get_company()
        }
        else{
          v <- selected_employee()
        }
        text_tokens <- getTeamSkillGap(df, v, input$skills)
        freq_text <- table(text_tokens)%>% sort(decreasing = T) %>% as.data.frame()
        
        # Render a bar plot
        ggplot(freq_text, aes(text_tokens, Freq))+
          geom_col(fill="#69b3a2")+theme_bw()+labs(title = "Team Skill Gaps")+
          theme(axis.title.x=element_blank(),axis.title.y=element_blank(),axis.text.x = element_text(size = 15,angle = 45, vjust = 1, hjust=1))
      }
    })
    
    
    
    
    #9
    output$sectorplot <- renderWordcloud2({
      if (input$company=="Software Giant"){
        chosen_sector_skills <- sector_df[sector_df$Sector=="Information Technology" &
                                            sector_df$Size=="Small", "All_skills"]
      } else{
        chosen_sector_skills <- sector_df[sector_df$Sector=="Information Technology" &
                                            sector_df$Size=="Small", "All_skills"]
        
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
    
    #10
    
    output$training_effect <- renderValueBox({
      if (nrow(selected_employee())==0){
        v <- get_company()
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
      valueBox(skilled_n, paste("out of",total_n, "Team members"))
    })
    
    
    # SL third page----------------------------------------------------------------------------
    values <- reactiveValues()
    # values$df <- df_empty
    observeEvent(input$add_btn, {
      newLine <- isolate(c(input$employee_name, input$employee_position, input$employee_skills))
      isolate(values$df <- rbind(values$df, newLine))
    })
    
    output$customize_table <- DT::renderDataTable(values$df)
    
    output$sectorplot2 <- renderWordcloud2({
      if (input$company_size != "All"){
        chosen_sector_skills <- sector_df[sector_df$Sector==input$company_sector &
                                            sector_df$Size==input$company_size, "All_skills"]
      } else{
        chosen_sector_skills <- sector_df[sector_df$Sector==input$company_sector, "All_skills"]
        
      }
      text_tokens <- scan(text = chosen_sector_skills,
                          what = "character",
                          quote = "",
                          sep = ",")
      freq_text <- table(text_tokens)%>%
        sort(decreasing = T) %>%
        as.data.frame()
      wordcloud2a(freq_text,
                  color = "random-light", size=0.3)
    })
    

    
    
    
}

# Run the application ---------------------------------------
shinyApp(ui = ui, server = server)

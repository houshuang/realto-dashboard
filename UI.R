########################################## filters #################################
#-----------filters
professionsList=c(
  "All" = "all",
  "Clothing designers" = "clothesDesigner",
  "Florists" = "florist",
  "Carpenters" = "carpenter",
  "Multimedia electronicians" = "multimediaElectronician",
  "Painter" = 'painter'
  #"Automatiker"="automatiker"
  # "Sanitaire"="sanitaire",
  # "ElectricalFitter"="electricalFitter",
  # "Mecanic Production"="mecanicProduction",
  # "PolyMecanic"="polyMecanic"
)

languageList=c(
  "All" = "all",
  "German" = "de",
  "French" = "fr",
  "Italian" = "it"
)
roleList=c(
  "All"="all",
  "Apprentice"="apprentice",
  "Teacher"="teacher",
  "Supervisor"="supervisor"
)
postTypeList=
  c(
    "All"="all",
    "standard post"="standard",
    "learnDoc"="learnDoc",
    "activity"="activity",
    "activity Submission"="activitySubmission",
    #"learningJournal"="learningJournal",
    "standardLd"="standardLd"
  )
########################################## UI #################################
header <- dashboardHeader(title = "REALTO dashboard")

sidebar <- dashboardSidebar(sidebarMenu(
  menuItem("Most active flows", tabName = "flows", icon = icon("dashboard")),
  menuItem("Most active users", tabName = "mostActiveUsers", icon = icon("th")),
  menuItem("Users", tabName = "uniqueUsers",    icon = icon("th") ),
  menuItem("All activity",tabName = "activity", icon = icon("th")),
  menuItem("Posts and Users/posts", tabName = "posts", icon = icon("th")),
  menuItem("Time analysis module", tabName = "Regularity", icon = icon("th")),
  menuItem("Activity analysis module", tabName = "Usersclusters", icon = icon("th")),
  menuItem("Network analysis module", tabName = "SocialNetwork", icon = icon("th")),
  menuItem("REALTO", icon = icon("file-code-o"), href = "https://www.realto.ch")
))


body <- dashboardBody(tabItems(
   #============================================= tab: activity #=============================================
  tabItem( tabName = "activity",
           dygraphOutput("rollerActivities"),
           flowLayout(
             sliderInput("rollPeriod", "Smoothing:", 1, 100, 1),
             uiOutput('activityProf_dropdown'),
             # selectInput("activityProf", "Professions", professionsList),
             selectInput( "activityLang",   "Languages",languageList),
             selectInput( "userRole",  "User role",     roleList    ),
             uiOutput('activitySchool_dropdown')
           ),
           h3(""),    htmlOutput("activitySql")
  ),
  
   #============================================= tab: posts #=============================================
  tabItem(    tabName = "posts",

              flowLayout(
                sliderInput("rollPeriodpost", "Smoothing:", 1, 100, 1),
                uiOutput('activityProfpost_dropdown'),
                # selectInput("activityProfpost","Professions",professionsList  ),
                selectInput( "activityLangpost","Languages", languageList),
                selectInput("userRolepost","User role",roleList),
                selectInput( "postType", "Post type", postTypeList),
                uiOutput('activitySchoolpost_dropdown')
              ),
              h3('Sequence of post Types by each individual user'),
              h5('Each rows represents one user, columns represent weeks/month, colors encode type of activity'),
              selectInput(   "posSeq_time_window",     "Time window:", c( "Week" = "week",  "Month" = "month")  ),
              plotOutput("usersPostSequencePlot"),
              h3('Number of posts over time'),
              dygraphOutput("rollerPost"),
              h3('Users and posts distribution'),
              plotOutput("postUsers"),  
              h3(""),    htmlOutput("postsql"),
              textOutput("postsUsersSql"),
              textOutput("usersPostSequenceSql")
  ),
  
   #============================================= tab:  uniqueUsers #=============================================
  tabItem(  tabName = "uniqueUsers",
            fluidRow(
              h3('Unique users/timeframe'),
              dygraphOutput("uniqueUsersPlot"),
              flowLayout(
                sliderInput("uniqueUsersSmoothing", "Smoothing:", 1, 100, 1),
                selectInput( "uniqueUsersGran", "Unique users per:",   c("Day" = "day",  "Week" = "week",    "Month" = "month" )  ),
                uiOutput('activityProfUnique_dropdown'),
                # selectInput("activityProfUnique", "Professions",professionsList  ),
                selectInput("activityLangUnique","Languages", languageList ),
                selectInput( "userRoleUnique","User role",roleList),
                uiOutput('activitySchoolUnique_dropdown')
                
              ),
              h3('Cumulative registered users'),
              plotOutput("cumulUsersPlot")
            ),
            
            h3(""),    htmlOutput("uniqueSql"),
            h3(""),    htmlOutput("cumulUsersSql")
  ),
   #============================================= tab:  most Active users #=============================================
  tabItem(tabName = "mostActiveUsers",
          DT::dataTableOutput("mostActiveTable"),
          h3(""),    htmlOutput("mostActiveUsersSql")
  ),
  
   #============================================= tab: platform usage clusters #=============================================
  tabItem(tabName = "Usersclusters",
          h3("Clusters of users based on their platform usage"),
          h5("Use slider below the chart to change the number of clustes."),
          plotOutput("usageClustersPlot"),
          flowLayout(
            sliderInput("users_clust_cnt:","Nubmer of clusters", 1, 9, 1),
            checkboxInput("NormalizeVals", 'Normalize values', value = FALSE, width = NULL),
            uiOutput('userClustProf_dropdown'),
            # selectInput("userClustProf", "Professions",professionsList  ),
            selectInput("userClustLang","Languages", languageList ),
            selectInput( "userClustRole","User role",roleList),
            uiOutput('userClustSchool_dropdown')
            
          ),
          plotOutput("usageBarPlot"),
          DT::dataTableOutput("usageTable"),
          h3(""),    htmlOutput("UsersclusterSql")
  ),
  
   #============================================= tab:  most Active flows #=============================================
  tabItem(tabName = "flows",
          DT::dataTableOutput("flowsTable"),
          h3(""),    htmlOutput("flowSql")
  ),
   #============================================= tab: Social network #=============================================
  tabItem(tabName = "SocialNetwork",
          h3("Social network of users"),
        #-----force net
          # forceNetworkOutput("socialNetPlot_force",width = "80%", height = "600px"),
        fluidRow(
          column(9, forceNetworkOutput("socialNetPlot_force", height = "600px")),
          column(3, DT::dataTableOutput("socialNetAttributesTable", height= "600px"))
        ),
        #---- options
          flowLayout(
            # selectInput( "socialLinkType","Link type: ",c("All"="'comment', 'like'" , "Comment" = "'comment'",  "Like" = "'like'" )  ),  
            selectInput( "socialLinkType","Link type: ",c("All"="all" , "Comment" = "comment",  "Like" = "like", 
                                                          "create LD"= "ld_create", "comment on LD"='ld_comment', "evaluate LD"="ld_feedback", 
                                                          'Social (comment, like)'='social',"LD (create, comment, evaluate)"='ld_all')),  
            selectInput( "socialRoleType","links bw. apprentices and: ",
                         c("All"="all" , "Other apprentices" = 'apprentice',"Teachers" = 'teacher',
                           "Supervisors" = 'supervisor', 'teacher and supervisor' ='teacher_supervisor') ),  
            uiOutput('socialProf_dropdown'),
            # selectInput("socialProf", "Professions",professionsList  ),
            selectInput("socialLang","Languages", languageList ),
            uiOutput('socialSchool_dropdown')
          ),
      #----- network attributes table
        # DT::dataTableOutput("socialNetAttributesTable"),
      #---------- blockmodel
        sliderInput("block_model_roles_cnt:","Nubmer of roles", 2, 6, 3),
#         plotOutput("blockModelPlot", width = "100%", height= "500px"),
#         DT::dataTableOutput("blockModeAttributesTable", width = "50%", height= "400px"),
      fluidRow(
        column(6, plotOutput("blockModelPlot", height= "400px")),
        column(6, DT::dataTableOutput("blockModeAttributesTable", height= "400px"))
        ),
      
      #-----sankey
          h3("Strongest connections"),
          # h5("Use slider to change the number of visualized connections."),
          sliderInput("social_num_link:","Nubmer of connections", 2, 300, 15),
          sankeyNetworkOutput("socialNetPlot_sankey",width = "100%", height = "450px"),
          # showOutput('socialNetPlot_sankey2', 'd3_sankey'),
          
      #------- sql query
          h3(""),  htmlOutput("socialNetSql")
  ),
   #============================================= tab:  Regularity #=============================================
  tabItem(tabName = "Regularity",
          #---- options
          flowLayout(
            uiOutput('regularity_flow_dropdown')
          ),
          h3("Regularity: Certain Week Day (CWD)"),
          plotOutput("CWD_reg_WeeklyHistPlot", width = "100%", height= "700px"),
          
          h3("Regularity: Certain Day Hour (CDH)"),
          plotOutput("CDH_reg_DailyHistPlot", width = "100%", height= "700px"),
          
          h3("Regularity: Weekly Similarity Binary (WSB)"),
          plotOutput("WSB_reg_WeeklyProfilePlot", width = "100%", height= "600px"),
          
          # DT::dataTableOutput("flows_Names_members_table"),
          #------- sql query
          h3(""),    htmlOutput("regularityUsersActions_Sql")
          
  )
))

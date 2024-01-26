base::source("packages.R")
base::source("global.r")

ui <- dashboardPage(skin = "black",
                    dbHeader,
                    dashboardSidebar(disable = TRUE),
                    dashboardBody(
                      box(
                        title = "Important Information",
                        background = "green",
                        width = 12,
                        p("This dashboard presents summarized data for one or multiple artists.
                                   Note : Only artists with at least 5 songs are included in the analysis.")
                      ),
                      box(
                        title = "Artist",
                        solidHeader = FALSE,
                        width = 6,
                        column(3, align = "center"),
                        column(6, align = "center",
                               pickerInput("artist_select", "",
                                           selected = "BTS",
                                           choices = sort(unique(spotify_data$artist_name)),
                                           multiple = TRUE),
                               column(3, align = "center")
                        ),
                        #   box(
                        #     title = "Chat with ChatGPT",
                        #     solidHeader = FALSE, 
                        #     width = 6,
                        #     column(3, align = "center"),
                        #     column(6, align = "center"),
                        #     column(3, align = "center")
                        #   ),
                              box(
                             title = "Stats",
                             solidHeader = FALSE,
                             width = 6,
                             br(),
                             fluidRow(
                        
                             )
                           ),
                        #   br(), 
                        #   box(title = "Track & playlist presence", 
                        #       ...,
                        #   )
                      )
                    ))


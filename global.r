##DATA MANAGEMENT
#Pour traiter les données

#### Lecture des data
spotify_data <- read.csv("data/spotify-2023.csv", 
                         stringsAsFactors = FALSE,
                         check.names = FALSE, quote = "\"",
                         header = TRUE, 
                         encoding = "UTF-8") %>%
#### A faire 
# renommer la colonne artist(s)_name en artist_name

  rename(artist_name = `artist(s)_name`) %>%

#convertir les valeurs de la colonne streams en nombres qui était en chaîne de charactères.

  mutate (streams = as.numeric(as.character(streams))) 
  
#### Traitement des artistes

# Séparation des artistes : Les noms des artistes sont séparés s'ils sont listés ensemble dans une même chaîne de caractères.
#création d'une colonne + séparation des données
spotify_data$id_artists <- strsplit(spotify_data$artist_name, ",")

# Nettoyage supplémentaire et formatage : Suppression des espaces superflus dans les noms des artistes.
#unnest duplique les artistes
spotify_data <- tidyr::unnest(spotify_data, id_artists)

#rapatrier la colonne artiste dans la colonne 
spotify_data$artist_name <- trimws(spotify_data$id_artists,
                                   which = "both")



# Filtrage des artistes :  ne garder que les artistes au moins 5 chansons.
#Nombre de chansons par artiste
spotify_data <- spotify_data %>%
  group_by(artist_name) %>%
  mutate(chansonsart = n()) %>%
  filter(chansonsart > 4) %>%
  ungroup()
  

#### Définition genre de musique 


# https://www.kine-formations.com/wp-content/uploads/2020/04/Liste-des-BPM-par-style-musical-Annexe-t%C3%A9l%C3%A9chargeable-%C3%A0-la-fin.pdf
#Dans case_when on a une succession de ligne sous la forme de switch
get_genre_by_bpm <- function(bpm) {
  case_when(
    bpm == 80 ~ "Crunk",
    bpm >= 60 & bpm <= 90 ~ "Dub",
    bpm >= 80 & bpm <= 90 ~ "Reggae",
    bpm >= 80 & bpm <= 100 ~ "Hip-hop",
    bpm >= 80 & bpm <= 120 ~ "Rock Folk",
    bpm >= 90 & bpm <= 120 ~ "Rock pop",
    bpm >= 50 & bpm <= 56 ~ "Tango",
    bpm >= 80 & bpm <= 100 ~ "Salsa",
    bpm >= 60 & bpm <= 120 ~ "Trip hop",
    bpm >= 70 & bpm <= 120 ~ "Soul Music",
    bpm >= 100 & bpm <= 120 ~ "Chillstep",
    bpm >= 120 & bpm <= 135 ~ "Minimal",
    bpm >= 125 & bpm <= 135 ~ "Funky house",
    bpm >= 126 & bpm <= 135 ~ "Electro",
    bpm >= 125 & bpm <= 140 ~ "House music",
    bpm >= 130 & bpm <= 140 ~ "Trance",
    bpm >= 135 & bpm <= 145 ~ "Dubstep",
    bpm >= 120 & bpm <= 150 ~ "Techno",
    bpm >= 170 & bpm <= 180 ~ "Rock Punk",
    bpm >= 150 & bpm <= 190 ~ "Drum’n’bass",
    bpm >= 60 & bpm <= 220 ~ "Jazz",
    bpm >= 80 & bpm <= 220 ~ "Rock",
    bpm >= 160 & bpm <= 230 ~ "Hardcore",
    bpm >= 200 & bpm <= 500 ~ "Speedcore",
    bpm > 1000 ~ "Extratone",
    TRUE ~ "Unknown"
  )
}

bpm_value <- 140
genre <- get_genre_by_bpm(bpm_value)
cat("For BPM =", bpm_value, "the genre is:", genre, "\n")

#Affecter la fonction get genre à la variable 
spotify_data <- spotify_data %>%
  mutate (Genre = get_genre_by_bpm(bpm))

#### Header application
dbHeader <- dashboardHeader()
dbHeader$children[[2]]$children <- tags$a(href='https://www.kaggle.com/datasets/nelgiriyewithana/top-spotify-songs-2023',
                                          tags$img(src='my_Logo.jpg',height='40',
                                                   width='130'))

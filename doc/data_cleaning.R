library(pacman)
pacman::p_load(dplyr)

current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path ))

characters = read.csv('../data/characters.csv')
dialogue = read.csv('../data/dialogue.csv')
movies = read.csv('../data/movies.csv')
places = read.csv('../data/places.csv')
chapters = read.csv('../data/chapters.csv')
spells = read.csv('../data/spells.csv')

dialogue$dialogue_no_spells=gsub(paste(spells$incantation,collapse='|'),"",dialogue$dialogue)

merged = merge(x = dialogue, y = characters, by = "character_id")
merged = merge(x = merged, y = chapters, by = "chapter_id")
merged = merge(x = merged, y = movies, by = "movie_id")
merged = merge(x = merged, y = places, by = "place_id")

df = merged[,c("dialogue_id","movie_title","movie_chapter","chapter_id","place_name","place_category","character_name","gender","house","species","dialogue","dialogue_no_spells")]

write.csv(df, "../data/cleaned.csv", row.names=FALSE)

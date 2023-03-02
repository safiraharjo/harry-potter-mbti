library(pacman)
pacman::p_load(dplyr)

library(dplyr)
library(tm) # for text mining
library(SnowballC) # for stemming
library(stringr) # for string manipulation

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

#write.csv(df, "../data/cleaned.csv", row.names=FALSE)

clean_text <- function(text) {
  # Convert to lowercase
  text <- tolower(text)
  
  # Remove punctuation
  text <- str_replace_all(text, "[[:punct:]]", "")
  
  # Remove numbers
  text <- str_replace_all(text, "\\d+", "")
  
  # Remove stop words
  text <- removeWords(text, stopwords("english"))
  
  # Stem words
  text <- wordStem(text)
  
  # Remove whitespace
  text <- str_trim(text)
  
  # Return cleaned text
  return(text)
}

# Apply cleaning function to text column
df$dialogue<- iconv(df$dialogue, from = 'ISO-8859-1', to = 'utf8')
df$dialogue_cleaned <- sapply(df$dialogue, clean_text)

write.csv(df, "../data/cleaned_nlp.csv", row.names=FALSE)









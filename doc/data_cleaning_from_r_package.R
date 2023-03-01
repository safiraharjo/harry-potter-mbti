#devtools::install_github('bradleyboehmke/harrypotter')
library(harrypotter)
library(pacman)
pacman::p_load(devtools, knitr, magrittr, dplyr, stringr, tidyr, ggplot2, text2vec, tm, tidytext, 
               stringr, stringi, SnowballC, stopwords, wordcloud, prettydoc, cowplot, kable, 
               utf8, corpus, glue, topicmodels, stm, wordcloud2, htmlwidgets, viridis)

titles <- c("Philosopher's Stone", "Chamber of Secrets", "Prisoner of Azkaban", "Goblet of Fire", 
            "Order of the Phoenix", "Half-Blood Prince", "Deathly Hallows")

# lapply(titles, data)
books <- list(philosophers_stone, chamber_of_secrets, prisoner_of_azkaban, goblet_of_fire, 
              order_of_the_phoenix, half_blood_prince, deathly_hallows)

# Save entire corpus
corpus <- c(philosophers_stone, chamber_of_secrets, prisoner_of_azkaban, goblet_of_fire, 
            order_of_the_phoenix, half_blood_prince, deathly_hallows)

# Save df with chapter as row and book as panel Each book is an array in which
# each value in the array is a chapter
df <- tibble()
for (i in seq_along(titles)) {
  temp <- tibble(chapter = seq_along(books[[i]]), text = books[[i]], book = titles[i])
  df <- rbind(df, temp)
}

# set factor to keep books in order of publication
df$book <- factor(df$book, levels = rev(titles))

df <- as.data.frame(df)

# split chapter name
#kalo mau separate per row satu paragraf juga bisa pake separator yg sama seperti di bawah
df2 <- separate(df, text, into = c("chapter_name", "text"), sep = "　　", extra = "merge")

df2$id <- row.names(df2)

library(pacman)
pacman::p_load(dplyr, stringr, tidyr, qdapRegex, stringi)

current_path = rstudioapi::getActiveDocumentContext()$path
setwd(dirname(current_path ))

df_phil = as.data.frame(readLines("../data/philosophers_stone.txt"))
colnames(df_phil)[1] ="text"
df_phil$book = "Philosopher's Stone"

df_phil$text = rm_between(
  df_phil$text,
  "==",
  "=="
)

df_phil$text = rm_between(
  df_phil$text,
  "[",
  "]"
)

df_phil$text = rm_between(
  df_phil$text,
  "(",
  ")"
)

df2 <- separate(df_phil, text, into = c("name", "text"), sep = ":", extra = "merge")
df2[df2==''] <- NA
df3 <- df2[rowSums(is.na(df2)) > 0,]
df2 <- df2[rowSums(is.na(df2)) == 0,]
df3 = subset(df3, select = -c(name) )
df4 <- separate(df3, text, into = c("name", "text"), sep = ":", extra = "merge")
df4 <- df4[rowSums(is.na(df4)) == 0,]

df_phil <- rbind(df2, df4)
df_phil$index <- as.numeric(row.names(df_phil))
df_phil[order(df_phil$index), ]

rownames(df_phil) <- NULL
df_phil = subset(df_phil, select = -c(index) )



# books <- list(philosophers_stone, chamber_of_secrets, prisoner_of_azkaban, goblet_of_fire, 
#               order_of_the_phoenix, half_blood_prince, deathly_hallows)
# titles <- c("Philosopher's Stone", "Chamber of Secrets", "Prisoner of Azkaban", "Goblet of Fire", 
#             "Order of the Phoenix", "Half-Blood Prince", "Deathly Hallows")
# df$book <- factor(df$book, levels = rev(titles))


library(tm)
library(proxy)
library(dplyr)
library(Matrix)
library(slam)

setwd("/Users/denisesonia/harry-potter-mbti")

# Load data from CSV files
data1 <- read.csv("data/mbti_1.csv", stringsAsFactors = FALSE, nrows = 1000)
data2 <- read.csv("data/cleaned_nlp.csv", stringsAsFactors = FALSE, nrows = 1000)

# Preprocessing function
preprocess <- function(x) {
  x <- tm_map(x, content_transformer(tolower))
  x <- tm_map(x, removePunctuation)
  x <- tm_map(x, removeWords, stopwords("english"))
  x <- tm_map(x, stripWhitespace)
  return(x)
}

# Create a corpus from the dataframes
corpus1 <- VCorpus(VectorSource(data1$posts))
corpus2 <- VCorpus(VectorSource(data2$dialogue))

# Preprocess the corpora
corpus1_clean <- preprocess(corpus1)
corpus2_clean <- preprocess(corpus2)

dtm1 <- DocumentTermMatrix(corpus1_clean)
dtm2 <- DocumentTermMatrix(corpus2_clean)



merged_dtms <- merge_columns(dtm1, dtm2)
dtm1_merged <- merged_dtms[[1]]
dtm2_merged <- merged_dtms[[2]]

normalize_rows <- function(mat) {
  row_norms <- sqrt(rowSums(mat^2))
  mat_normalized <- mat
  for (i in 1:nrow(mat)) {
    mat_normalized[i, ] <- mat_normalized[i, ] / row_norms[i]
  }
  return(mat_normalized)
}

cosine_similarity <- function(vec1, vec2) {
  vec1_norm <- sqrt(sum(vec1^2))
  vec2_norm <- sqrt(sum(vec2^2))
  similarity <- as.numeric(vec1 %*% vec2 / (vec1_norm * vec2_norm))
  if (is.na(similarity)) {
    return(0)
  }
  return(similarity)
}

similarity_score <- cosine_similarity(dtm1_merged[1, ], dtm2_merged[1, ])
print(similarity_score)



# Function to merge the columns of two document-term matrices
merge_columns <- function(dtm1, dtm2) {
  terms1 <- colnames(dtm1)
  terms2 <- colnames(dtm2)
  common_terms <- union(terms1, terms2)
  
  dtm1_dtm <- t(dtm1) # Convert TermDocumentMatrix to DocumentTermMatrix
  dtm2_dtm <- t(dtm2) # Convert TermDocumentMatrix to DocumentTermMatrix
  
  dtm1_simple_triplet <- as.simple_triplet_matrix(dtm1_dtm) # Convert DocumentTermMatrix to simple_triplet_matrix
  dtm2_simple_triplet <- as.simple_triplet_matrix(dtm2_dtm) # Convert DocumentTermMatrix to simple_triplet_matrix
  
  dtm1_new <- sparseMatrix(i = dtm1_simple_triplet$i + 1, j = match(rownames(dtm1_dtm)[dtm1_simple_triplet$j + 1], common_terms), x = dtm1_simple_triplet$v, dims = c(max(dtm1_simple_triplet$i) + 1, length(common_terms)))
  dtm2_new <- sparseMatrix(i = dtm2_simple_triplet$i + 1, j = match(rownames(dtm2_dtm)[dtm2_simple_triplet$j + 1], common_terms), x = dtm2_simple_triplet$v, dims = c(max(dtm2_simple_triplet$i) + 1, length(common_terms)))
  
  colnames(dtm1_new) <- common_terms
  colnames(dtm2_new) <- common_terms
  
  return(list(dtm1_new, dtm2_new))
}




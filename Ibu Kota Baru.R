##contoh script dasar untuk scraping data twitter

#simpan file di directory yang sudah ditentukan
getwd()

#install semua packages yang dibutuhkan
install.packages("rtweet")
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("tidyverse")
install.packages("tidytext")
install.packages("wordcloud2")
install.packages("sigmajs")
install.packages("lubridate")

#load semua packages yang dibutuhkan

library(rtweet)
library(ggplot2)
library(gridExtra)
library(tidyverse)
library(graphTweets)
library(wordcloud2)
library(sigmajs)
library(lubridate)
library(readr) # to read and write files 
library(tidytext) # text mining
library(dplyr)  # data reshaping & restructuring
library(stringr) # to manipulate string variables
library(forcats) # for factors
library(tidyr) # to tidy data
library(reshape2) # reshape data
library(textdata) # to get sentiment libraries



#mendaftarkan akun twitter dev 

create_token(app = "ibu_kota_baru",
             consumer_key = "xE6nVqMmGQSlhiOlm0Fs9oZYa",
             consumer_secret = "p8OtfqsOsQdf8Sb29OZgK7draJBUl6CRJCnF9lPsel43lByo47",
             access_token = "236702993-bBzXtpXRqi3LqeqfnncIJ4gyr5mIhPme2hEWqkjv",
             access_secret = "te9INa1dV6ZcIuUSnwsW2M8RRfSbtfnrsa5zUqdudBz1K")


#jika sudah, maka kita sudah bisa menggunakan package rtweet

##menggunakan keywords atau hastags: 

ibukotabaru <- search_tweets("ibu kota baru", n = 18000 , retryonratelimit = TRUE, lang = "id")


#jika tidak ingin mengikutsertakan data retweet, maka perlu ditambahkan perintah: include_rts = FALSE

ibukotabaru <- search_tweets("#ibukotabaru" , n = 18000 , include_rts = FALSE, retryonratelimit = TRUE, lang = "id")


#jika dataset yang kita minta lebih dari 18,000, twitter akan memberikan jeda 15menit

#jangan lupa simpan file yang sudah selesai kita download ke dalam format .csv


save_as_csv(ibukotabaru, file_name = "IbuKotaBaru.csv", prepend_ids = TRUE, na = "",
            fileEncoding = "UTF-8")

# buka file nya
ibukotabaru <- read_csv("IbuKotaBaru.csv")

# filter isi tweet saja
ibukota_filter <- IbuKotaBaru %>% 
  select(text)

##cleaning text

ibukota_filter %>% 
  select(text) %>% 
  mutate(text = gsub(pattern = "http\\S+", 
                     replacement = "", 
                     x = text)) %>% 
  mutate(text = gsub(pattern = "#", 
                     replacement = "", 
                     x = text)) %>% 
  mutate(text = gsub(pattern = "\\d+",
                     replacement = "",
                     x = text)) %>% 
  mutate(text = gsub(pattern = "@", 
                     replacement = "", 
                     x = text)) %>% 
  plain_tweets() -> ibukota_filter


#simpan file teks ke dalam format .txt untuk keperluan 'analisis teks' (optional)

write.table(ibukota_filter, file = "text_cleaned.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

# buka file Stopwords untuk membersihkan kata hubung

stopwords <- read_csv("stopwords-id.txt", 
                      col_names = "stopwords")

# membuat 'token' dan menghapus stopwords (pastikan anda punya file list stopwords di direktori yang sama)

ibukota_filter %>%   
  unnest_tokens(input = text, output = token) %>% 
  count(token, sort = T)


# visualisasinya

ibukota_filter %>% 
  unnest_tokens(input = text, output = token) %>% 
  anti_join(stopwords, by = c("token" = "stopwords")) %>% 
  count(token, sort = T) %>% 
  wordcloud2(size = 0.5)


ibukota_filter %>%   
  unnest_tokens(input = text, output = token) %>% 
  count(token, sort = T) %>%
  top_n(100) %>%
  mutate(token = reorder(token, n)) %>%
  ggplot(aes(x = token, y = n)) +
  geom_col(fill="black") +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Kata Yang Paling Banyak Muncul Di Tweet",
       subtitle = "Setelah Stop Words Dihilangkan")

# simpan wordcount untuk visualisasi manual
visual <- ibukota_filter %>%   
  unnest_tokens(input = text, output = token) %>% 
  count(token, sort = T) %>%
  top_n(100)

save_as_csv(visual, file_name = "wordcloud.csv", prepend_ids = TRUE, na = "",
            fileEncoding = "UTF-8")


# Bersihkan whitespace 

ibukota_filter %>%  
  mutate(text=str_trim(text, side = "both"))

# tambahkan row number

ibukota_filter$row_num <- seq.int(nrow(ibukota_filter)) 

# generate ngram

text_sentiment <- ibukota_filter %>%
  unnest_tokens(word, text, token = "ngrams", n = 1)

# Buka file sentimen (pastikan file sentimen sudah ada di direktori yang sama)

# Gabungkan file text_sentiment dengan sentiment_value

text_sentiment_2 <- text_sentiment %>%
  inner_join(Sentiment_Value) %>%
  group_by(word)

# sum up all the sentiment values for each comment

text_sentiment_3 <- text_sentiment_2 %>%
  group_by(row_num) %>%
  summarise(sentiment = sum(Polarity))

# collapse back all together by row_number

sentiment_all <- text_sentiment_3 %>% 
  full_join(ibukota_filter, by="row_num") %>%
  group_by(row_num)

# simpan file

save_as_csv(sentiment_all, file_name = "Analisis_sentimen.csv", prepend_ids = TRUE, na = "",
            fileEncoding = "UTF-8")


# Getting Youtube Comments

# load the required packages
library(tuber)
library(tidyverse)

# store the name of your Client ID in app_name variable 
app_id <- "273572675922-fv2of7rf75b5fqrl8kcok547g5v4vg4b.apps.googleusercontent.com"

# store the Client secret in the app_secret variable 
app_secret <- "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"

# authorize your app
yt_oauth(app_id, app_secret, token = "")

# Get omments under the video Mata Najwa Menelusuri Ibu Kota Baru (7 video)
video_1 <- get_all_comments(video_id = "qfziz8HK6BY")

video_2 <- get_all_comments(video_id = "7Vip6uYAt54")

video_3 <- get_all_comments(video_id = "fWA9JcRFL2Q")

video_4 <- get_all_comments(video_id = "PquDlm7IKbI")

video_5 <- get_all_comments(video_id = "0brQRGsRZNo")

video_6 <- get_all_comments(video_id = "i9VY9n9HApU")

video_7 <- get_all_comments(video_id = "8f8K5_aIyHg")


# Satukan semua comment dalam satu dataset

All_rows <- merge(video_6, video_7, all=TRUE)

All_rows <- merge(video_5, All_rows, all=TRUE)

All_rows <- merge(video_4, All_rows, all=TRUE)

All_rows <- merge(video_3, All_rows, all=TRUE)

All_rows <- merge(video_2, All_rows, all=TRUE)

All_rows <- merge(video_1, All_rows, all=TRUE)

# simpan dataset utama

write.csv(All_rows, "Mata Najwa Comments.csv")

# filter isi comment saja

rows_filter <- All_rows %>% 
  select(textOriginal)

##cleaning text

rows_filter %>% 
  select(textOriginal) %>% 
  mutate(textOriginal = gsub(pattern = "http\\S+", 
                     replacement = "", 
                     x = textOriginal)) %>% 
  mutate(textOriginal = gsub(pattern = "#", 
                     replacement = "", 
                     x = textOriginal)) %>% 
  mutate(textOriginal = gsub(pattern = "\\d+",
                     replacement = "",
                     x = textOriginal)) %>% 
  mutate(textOriginal = gsub(pattern = "@", 
                     replacement = "", 
                     x = textOriginal))


#simpan file teks ke dalam format .txt untuk keperluan 'analisis teks' (optional)

write.table(rows_filter, file = "text_cleaned_youtube.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

# buka file Stopwords untuk membersihkan kata hubung

stopwords <- read_csv("stopwords-id.txt", 
                      col_names = "stopwords")

# membuat 'token' dan menghapus stopwords (pastikan anda punya file list stopwords di direktori yang sama)

rows_filter %>%   
  unnest_tokens(input = textOriginal, output = token) %>% 
  count(token, sort = T)


# visualisasinya

rows_filter %>% 
  unnest_tokens(input = textOriginal, output = token) %>% 
  anti_join(stopwords, by = c("token" = "stopwords")) %>% 
  count(token, sort = T) %>% 
  wordcloud2(size = 0.5)

rows_filter %>%   
  unnest_tokens(input = textOriginal, output = token) %>% 
  count(token, sort = T) %>%
  top_n(100) %>%
  mutate(token = reorder(token, n)) %>%
  ggplot(aes(x = token, y = n)) +
  geom_col(fill="black") +
  xlab(NULL) +
  coord_flip() +
  labs(y = "Count",
       x = "Unique words",
       title = "Kata Yang Paling Banyak Muncul Di Comment",
       subtitle = "Setelah Stop Words Dihilangkan")

# simpan wordcount untuk visualisasi manual

visual <- rows_filter %>%   
  unnest_tokens(input = textOriginal, output = token) %>% 
  count(token, sort = T) %>%
  top_n(100)

write.csv(visual, "wordcloud_youtube.csv")

# Bersihkan whitespace 

rows_filter %>%  
  mutate(text=str_trim(textOriginal, side = "both"))

# tambahkan row number

rows_filter$row_num <- seq.int(nrow(rows_filter)) 

# generate ngram

youtube_sentiment <- rows_filter %>%
  unnest_tokens(word, textOriginal, token = "ngrams", n = 1)

# Buka file sentimen (pastikan file sentimen sudah ada di direktori yang sama)

# Gabungkan file text_sentiment dengan sentiment_value

youtube_sentiment_2 <- youtube_sentiment %>%
  inner_join(Sentiment_Value) %>%
  group_by(word)

# sum up all the sentiment values for each comment

youtube_sentiment_3 <- youtube_sentiment_2 %>%
  group_by(row_num) %>%
  summarise(sentiment = sum(Polarity))

# collapse back all together by row_number

all_sentiment <- youtube_sentiment_3 %>% 
  full_join(rows_filter, by="row_num") %>%
  group_by(row_num)

# simpan file

write.csv(all_sentiment, "sentimen_youtube.csv")

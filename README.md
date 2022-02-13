# Analisis-Sentimen-Twitter-dan-YouTube
Analisis sentimen cuitan "Ibu Kota Baru" dan komentar video YouTube Reportase Mata Najwa "Menelusuri Ibu Kota Baru"

Menggunakan Twitter API, saya mengumpulkan tweet dengan kata kunci "Ibu Kota Baru" selama 7 hari terakhir (20/01/2022 sampai 26/01/2022). Kemudian, saya melakukan analisis sentimen dengan R, dengan dictionary 'Bahasa Indonesia' yang disediakan oleh [ID-OpinionWords](https://github.com/masdevid/ID-OpinionWords). 

Saya juga mengumpulkan komentar YouTube dari tujuh video reportase Mata Najwa "[Menelusuri Ibu Kota Baru](https://www.youtube.com/watch?v=qfziz8HK6BY)". Pengumpulan data dilakukan melalui Youtube Data API, kemudian, analisis sentimen dilakukan dengan R, dengan menggunakan dictionary seperti disebutkan.

Tahapan dalam analisis data:
* [Scraping dan analisis data dengan R](https://github.com/garnesian/Analisis-Sentimen-Twitter-dan-YouTube/blob/main/Ibu%20Kota%20Baru.R)
*

Data dalam analisis:
* [Teks "Ibu Kota Baru" yang sudah dibersihkan](https://github.com/garnesian/Analisis-Sentimen-Twitter-dan-YouTube/blob/main/text_cleaned.txt)
* [Komentar YouTube "Reportase Mata Najwa" sudah dibersihkan](https://github.com/garnesian/Analisis-Sentimen-Twitter-dan-YouTube/blob/main/text_cleaned_youtube.txt)
* [Hasil analisis sentimen Twitter](https://github.com/garnesian/Analisis-Sentimen-Twitter-dan-YouTube/blob/main/Sentiment_Value.csv)
* [Hasil analisis sentimen YouTube](https://github.com/garnesian/Analisis-Sentimen-Twitter-dan-YouTube/blob/main/text_cleaned_youtube.txt)



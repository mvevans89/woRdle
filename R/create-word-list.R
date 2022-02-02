#create word list

# words from https://www-cs-faculty.stanford.edu/~knuth/sgb-words.txt
# all.words <- unlist(read.table("sgb-words.txt"))
# #drop words not in dictionary
# misspelled <- spell_check_text(all.words)
# good.words <- all.words[!(all.words %in% misspelled$word)]
# #create data.frame of words and dates
# word.df <- data.frame(date = seq.Date(as.Date("2022-02-01"), by = "day", length.out = length(good.words)),
#                       word = sample(good.words, length(good.words)))
#save
# write.csv(word.df, "final-words.csv", row.names = F) #already saved

# all.words <- read.csv("data/final-words.csv")
# all.words$date <- as.Date(all.words$date)
# usethis::use_data(all.words, internal = T, overwrite = T)

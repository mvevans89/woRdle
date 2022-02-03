# source functions

play_woRdle <- function(date2play = Sys.Date()){
  #' master function to play
  #' @param date2play the date of the world you want to play, defaults to today's date
  #' play_woRdle(Sys.Date()+9)

  #identify today's word
  #check that the date supplied is in our file
  if(date2play %in% all.words$date){
    word.ind <- which(as.Date(all.words$date)==date2play)
    today.word <- toupper(all.words$word[word.ind])
  } else {
    print("The date you entered was not valid. Try again by using the Sys.Date()")
    stop()
  }
  today.word.list <- c(unlist(strsplit(today.word, split = "")))

  #set up the plot
  par(mfrow = c(6,5), mar = rep(0.2,4), bg = "#121213")
  #set up matrix for score sharing
  guess.matrix <- list()


  # guessing ########
  round.num = 1
  letters.guessed <- c()

  for(i in 1:6){
    this.guess <- guess_fn(round.num, today_word = today.word, today_word_list = today.word.list,
                           letters_guessed = letters.guessed)


    #check it is actually a word, has 5 letters, and is only letters
    word.check <- check_is_word(paste0(this.guess$guess, collapse = ""))
    valid.symbols <- check_valid_letters(this.guess$guess)
    #will be true if fails any of three checks
    full.check <- word.check == "not_a_word" | length(this.guess$guess) != 5 | valid.symbols != "valid"
    while(full.check){ #if not a word, request a new one
      print(paste0("The word you guessed (", paste0(this.guess$guess, collapse = ""),") is not a 5-letter word. Please guess again"))
      this.guess <- guess_fn(round.num, today_word = today.word, today_word_list = today.word.list,
                             letters_guessed = letters.guessed)
      word.check <- check_is_word(paste0(this.guess$guess, collapse = ""))
      valid.symbols <- check_valid_letters(this.guess$guess)
      full.check <- word.check == "not_a_word" | length(this.guess$guess) != 5 | valid.symbols != "valid"
    }

    #keep track of score
    guess.matrix[[i]] <- create_score_line(this.guess$color.index)
    #keep track of letters guessed
    letters.guessed <- unique(sort(c(letters.guessed, this.guess$guess)))

    #plot of current guess
    Map(plot_location,
        color_ind = this.guess$color.index,
        guess_letter = this.guess$guess)


    #evaluate, if guess is correct then break
    if(sum(this.guess$color.index==3)==5){
      break

    }
    round.num <- round.num + 1
  }
  #return ascii to share
  # print(c("Great!", "Splendid!", "Good Job!", "Awesome!")[sample(1:4,1)])
  #print
  if(round.num == 7){
    print(paste0("woRdle #", word.ind, " : ", i, "Not completed"))
  } else  print(paste0("woRdle #", word.ind, " : ", i, "/6"))

  cat(unlist(guess.matrix), sep = "\n")

  #you failed! so I guess you can know the word now
  if(round.num == 7){
    print(paste0("Today's word : ", today.word))
  }

}


plot_location <- function(color_ind, guess_letter){
  #decide the color
  this.color <- c("#3A3A3C", "#B1A04C", "#618B55")[color_ind]
  #blank plot
  plot(1, type = "n",
       xlab = "", ylab = "",
       xlim = c(0, 10), ylim = c(0, 10),
       xaxt='n', yaxt = 'n')
  #set color based on letter
  rect(par("usr")[1], par("usr")[3],
       par("usr")[2], par("usr")[4],
       col = this.color) # Color
  text(5,5, label = guess_letter, cex = 4)
}

guess_fn <- function(round.num,
                  today_word = today.word,
                  today_word_list = today.word.list,
                  letters_guessed = letters.guessed){
  print(paste("Letters Guessed:", paste(letters_guessed, collapse = ", ")))
  print("- - - - - - - - - - - - - - - - - - - - - - - - -")
  this.guess <- toupper(readline(paste("Round", round.num, "guess:")))
  this.guess.list <- c(unlist(strsplit(this.guess, split = "")))

  wrong.location <- sapply(this.guess.list, grepl, today_word)
  suppressWarnings({ #suppress for when words of wrong length are guessed
    right.location <- this.guess.list == today_word_list
    color.index <- wrong.location + right.location +1
    })



  return(list(color.index = color.index, guess = this.guess.list))

}

check_is_word <- function(guessed_word){
  #' @import spelling
  #use spelling package to check it is a word
  spell.check <- spelling::spell_check_text(guessed_word, ignore = character(), lang = "en_US")
  if(nrow(spell.check)>0){
    return("not_a_word")
  } else return("word_confirmed")
}

check_valid_letters <- function(guessed_word){
  #check that all the letters are valid letters of roman alphabet
  num.letters <- sum(guessed_word %in% LETTERS)
  if(num.letters != 5){
    return("not_valid")
  } else return("valid")
}

create_score_line <- function(guess_color_index){
  # symbol.choice <- c(":(", ":|", ":)")
  symbol.choice <- c("X", "°", "0")
  #creates the ascii score line
  top <- "  _ _ _ _ _ _ _ _ _  "
  # top.blank <- "             "
  bottom <- " ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ ¯ "
  # middle.blank <- " |.| |.| |.| |.| |.| "
  middle <- paste0(" |", symbol.choice[guess_color_index[1]], "| |",
                   symbol.choice[guess_color_index[2]], "| |",
                   symbol.choice[guess_color_index[3]], "| |",
                   symbol.choice[guess_color_index[4]], "| |",
                   symbol.choice[guess_color_index[5]], "| ")
  # middle.nobar <- paste0(" ", symbol.choice[guess_color_index[1]], "   ",
  #                        symbol.choice[guess_color_index[2]], "   ",
  #                        symbol.choice[guess_color_index[3]], "   ",
  #                        symbol.choice[guess_color_index[4]], "   ",
  #                        symbol.choice[guess_color_index[5]], "   ")
  return(c(top,middle, bottom))
}

# cat(create_score_line(c(1,2,3,2,1)), sep = "\n")

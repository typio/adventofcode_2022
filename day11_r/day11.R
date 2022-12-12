args <- commandArgs()

for (arg in args) {
  if (substr(arg, nchar(arg)-3, nchar(arg)) == ".txt") {
    text <- readLines(arg) # no block level scoping? 
  }
}

text <- gsub("  ", "", gsub(",", "", text))

items = list()
operations = list()
test_mods = list()
true_throws = list()
false_throws = list()

for (t in text) {
  if (length(grep("Starting items:", t)) != 0) {
    words <- strsplit(t, " ")[[1]]
    numbers <- as.numeric(words[grepl("[0-9]+", words)])
    items <- append(items, list(numbers))
  }else if (length(grep("Operation:", t)) != 0) {
    words <- strsplit(t, " ")[[1]]
    last_two <- tail(words, 2)
    ops <- c(last_two[1],last_two[2])
    operations <- append(operations, list(ops))
  }else if (length(grep("Test:", t)) != 0) {
    words <- strsplit(t, " ")[[1]]
    test_mods <- append(test_mods, as.numeric(tail(words,1)))
  } else if (length(grep("If true:", t)) != 0) {
    words <- strsplit(t, " ")[[1]]
    true_throws <- append(true_throws, tail(words,1))
  } else if (length(grep("If false:", t)) != 0) {
    words <- strsplit(t, " ")[[1]]
    false_throws <- append(false_throws, tail(words,1))
  } 
}

monkey_inspects <- rep(0, length(items))

test_mods_LCM = prod(unlist(test_mods))

for (j in 1:10000) {
  for (i in 1:length(items)) {
    for (item in items[[i]]) {
      monkey_inspects[[i]] <- monkey_inspects[[i]] + 1

      old = item
      op <- operations[[i]][1]
      operand <- operations[[i]][2]

      if (op == "*") {
        new <- if (!is.na(as.numeric(operand))) old * as.numeric(operand) else old * old
      } else if (op == "+") {
        new <- if (!is.na(as.numeric(operand))) old + as.numeric(operand) else old + old
      }
      # new <- floor(new)
      while (new - test_mods_LCM > 0) {
        new <- new - test_mods_LCM
      }
      to_monkey <- (if (new %% test_mods[[i]] == 0) true_throws[[i]] else false_throws[[i]])
      to_monkey <- as.numeric(to_monkey) + 1
      items[[to_monkey]] <- c(items[[to_monkey]], new)
    }
    items[[i]] <- list()
  }
  print(j)
}
print(items)
print(monkey_inspects)
print(max(monkey_inspects) * max(monkey_inspects[monkey_inspects != max(monkey_inspects)]))

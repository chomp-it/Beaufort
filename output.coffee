
flashcardsDiv = document.getElementById('flashcards')
flipFlashcard = document.getElementById('flip-flashcard')
nextFlashcard = document.getElementById('next-flashcard')

printedMessage = false

printMessage = (message) ->
  if printedMessage is true then return # don't stack messages on top of each other

  h3 = document.createElement('h3')
  h3.textContent = message
  h3.style = "display: flex; flex-direction: column; align-items: center"

  document.body.appendChild(h3)

  printedMessage = true

  setTimeout (->
    document.body.removeChild(h3)
    printedMessage = false
  ), 1500



parseInput = (input) ->
  lines = input.split '\n'

  flashcards = []

  lines.forEach (line) ->
    match = line.match(/_([^_]+)_/)

    return unless match

    answer = match[1]

    blanks = '_'.repeat(answer.length)

    line = line.replace(/_([^_]+)_/, blanks)

    flashcards.push(
      question: line,
      answer: answer
    )

  return flashcards

generateFlashcards = (input) ->
  lines = input.split '\n'

  flashcards = []

  lines.forEach (line) ->
    # console.log "line:", line
    if line == '' then return

    words = line.split(' ').filter (word) -> word.length > 3

    # get a random word from the line
    randomWord = words[Math.floor(Math.random() * words.length)]

    blanks = '_'.repeat(randomWord.length)

    line = line.replace(randomWord, blanks)

    flashcards.push(
      question: line,
      answer: randomWord
    )

  return flashcards

parseInputWithCapitalization = (input) ->
  lines = input.split '\n'

  flashcards = []

  lines.forEach (line) ->
    match = line.match(/\b(([A-Z]+){2,})\b/)

    return unless match

    answer = match[1]

    blanks = '_'.repeat(answer.length)

    line = line.replace(/\b(([A-Z]+){2,})\b/, blanks)

    flashcards.push(
      question: line,
      answer: answer
    )

  return flashcards

generateFlashcardsFromMarkdown = (input) ->
  lines = input.split '\n'

  flashcards = []

  lines.forEach (line) ->
    match = line.match(/\*\*([^*]+)\*\*/)

    return unless match

    answer = match[1]

    blanks = '_'.repeat(answer.length)

    line = line.replace(/\*\*([^*]+)\*\*/, blanks)

    flashcards.push(
      question: line,
      answer: answer
    )

  return flashcards

input = sessionStorage.getItem('input')

if input is null
  printMessage 'No input found'
  return

shouldGenerateFlashcards = sessionStorage.getItem("generate-flashcards")

useCapitalization = sessionStorage.getItem("use-capitalization-for-answers")

fileIsMarkdown = sessionStorage.getItem("input-is-markdown")

if shouldGenerateFlashcards is "true" and useCapitalization is "true"
  alert "something went wrong"
  window.location.href = 'index.html'

if shouldGenerateFlashcards is "true"
  flashcards = generateFlashcards input
else if fileIsMarkdown is "true"
  flashcards = generateFlashcardsFromMarkdown input
else
  flashcards = parseInput input

if useCapitalization is "true"
  flashcards = parseInputWithCapitalization(input)

if flashcards.length is 0
  printMessage 'No flashcards found'

iterator = 0

handleNextFlashcard = ->
  flashcardAnswer = document.getElementById('flashcard-answer')

  flashcard = flashcards[iterator]

  flashcardQuestion = document.getElementById('flashcard-question')

  h3 = document.createElement('h3')

  if iterator is flashcards.length
    printMessage "That was your final flashcard."
    return

  h3.textContent = flashcard.question
  h3.id = 'flashcard-question'

  # check if a flashcards is currently being displayed
  if flashcardQuestion == null
    flashcardsDiv.appendChild(h3)
    flashcardsDiv.removeChild(flashcardAnswer) if flashcardAnswer
    iterator += 1
    return

  flashcardsDiv.replaceChild(h3, flashcardQuestion) # if the flashcard isn't the first flashcard
  flashcardsDiv.removeChild(flashcardAnswer) if flashcardAnswer # remove the answer
  iterator += 1


handleFlippingFlashcard = ->

  flashcardAnswer = document.getElementById('flashcard-answer')
  flashcard = flashcards[iterator - 1]

  h3 = document.createElement('h3')
  h3.textContent = flashcard.answer
  h3.id = 'flashcard-answer'

  if flashcardAnswer == null
    flashcardsDiv.appendChild(h3)
    return

  flashcardsDiv.replaceChild(h3, flashcardAnswer)



nextFlashcard.addEventListener 'click', ->
  handleNextFlashcard()

flipFlashcard.addEventListener 'click', ->
  handleFlippingFlashcard()

nextFlashcard.click() # load the first flashcard automatically

console.log "loaded"
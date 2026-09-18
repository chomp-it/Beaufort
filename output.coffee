
flashcardsDiv = document.getElementById('flashcards')
flipFlashcard = document.getElementById('flip-flashcard')
nextFlashcard = document.getElementById('next-flashcard')


printMessage = (message) ->
  h3 = document.createElement('h3')
  h3.textContent = message
  h3.style = "display: flex; flex-direction: column; align-items: center"

  document.body.appendChild(h3)

  setTimeout (-> document.body.removeChild(h3)), 3000
  console.log "done"



parseInput = (input) ->
  lines = input.split '\n'

  flashcards = []

  lines.forEach (line) ->
    match = line.match(/_([^_]+)_/)

    return unless match

    answer = match[1]

    console.log "answer:", answer

    line = line.replace(/_([^_]+)_/, "_________")

    flashcards.push(
      question: line,
      answer: answer
    )

  return flashcards

input = sessionStorage.getItem('input')

if input is null
  printMessage 'No input found'
  return

flashcards = parseInput(input)


if flashcards.length is 0
  printMessage 'No flashcards found'

flashcards.forEach ((flashcard) ->
  console.log flashcard.question
  console.log flashcard.answer
)

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


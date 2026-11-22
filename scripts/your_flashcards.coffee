
flashcardsContainer = document.getElementById "your-flashcards-container"

addNewDeckButton = document.getElementById "add-deck"

addNewDeckInterface = document.getElementById "add-deck-interface"

saveDeckButton = document.getElementById "save-deck"

foundFlashcards = JSON.parse(localStorage.getItem "decks")

printMessage = (message) ->
  h3 = document.createElement "h3"
  h3.className = "psuedoparagraph"
  h3.innerHTML = message
  h3.style.textAlign = "center"
  document.body.appendChild h3

  setTimeout ->
    document.body.removeChild h3
  , 2000

if foundFlashcards == null
  h3 = document.createElement "h3"
  h3.className = "psuedoparagraph"
  h3.innerHTML = "You don't have any saved flashcards yet. But you can add some!"
  flashcardsContainer.appendChild h3

handleAddingNewDeck = ->
  if addNewDeckInterface.style.display == "block"
    addNewDeckInterface.style.display = "none"
  else
    addNewDeckInterface.style.display = "block"

saveDeck = ->
  rawInput = document.getElementById "input"

  useCapitalization = document.getElementById "use-capitalization-for-answers"

  useMarkdown = document.getElementById "use-markdown-for-answers"

  if rawInput.value.length is 0
    printMessage "You need to enter a deck name"
    return

  if useCapitalization.checked
    parsedInput = parseWithCapitalization()
  else if  useMarkdown.checked
    parsedInput = parseWithMarkdown()
  else
    parsedInput = parseNormally()


loadSavedFlashcards = ->
  if foundFlashcards == null
    printMessage "Nothing to load"
    return

  for deck of foundFlashcards
    flashcardsContainer.innerHTML += ""

addNewDeckButton.addEventListener "click", ->
  handleAddingNewDeck()

saveDeckButton.addEventListener "click", ->
  saveDeck()

loadSavedFlashcards()
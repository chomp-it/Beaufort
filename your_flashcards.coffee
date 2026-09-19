
flashcardsContainer = document.getElementById "flashcards-container"

addNewDeckButton = document.getElementById "add-deck"

addNewDeckInterface = document.getElementById "add-deck-interface"

foundFlashcards = localStorage.getItem "saved_flashcards"

unless foundFlashcards? and foundFlashcards.length > 0
  h3 = document.createElement "h3"
  h3.innerHTML = "You don't have any saved flashcards yet. But you can add some!"
  flashcardsContainer.appendChild h3

handleAddingNewDeck = ->
  addNewDeckInterface.style.display = "block"

addNewDeckButton.addEventListener "click", ->
  handleAddingNewDeck()

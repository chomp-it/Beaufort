
submitButton = document.getElementById('submit')

rawTextField = document.getElementById('input')

submitFileInstead = document.getElementById('input-file-instead')

submitFileField = document.getElementById('file-input-container')

rawTextFieldLabel = document.getElementById('raw-input-label')

fileInput = document.getElementById('file-input')

seeMoreOptionsButton = document.getElementById('see-more-options')

moreOptionsDiv = document.getElementById('other-options')

generateFlashcardsCheckbox = document.getElementById('generate-flashcards')

useCapitalizationCheckbox = document.getElementById('use-capitalization-for-answers')

# submitting a file instead of pasting text
usingFileInstead = false

handleSubmitEvent = ->
  if rawTextField.value.length is 0
    alert 'Your input is empty.'
    return

  if generateFlashcardsCheckbox.checked and useCapitalizationCheckbox.checked
    alert 'You cannot use capitalization for answers when generating flashcards.'
    return

  if generateFlashcardsCheckbox.checked
    sessionStorage.setItem('generate-flashcards', 'true')
  else
    sessionStorage.setItem('generate-flashcards', 'false')

  if useCapitalizationCheckbox.checked
    sessionStorage.setItem('use-capitalization-for-answers', 'true')
  else
    sessionStorage.setItem('use-capitalization-for-answers', 'false')

  sessionStorage.setItem('input', rawTextField.value)

  window.location.href='output.html'

handleFileSubmitting = ->
  if usingFileInstead
    rawTextField.style.display = 'block'
    submitButton.style.display = 'block'
    rawTextFieldLabel.style.display = 'block'

    submitFileInstead.innerText = "Actually, I want to use a file instead"

    submitFileField.style.display = 'none'

    usingFileInstead = false
    return

  rawTextField.style.display = 'none'
  submitButton.style.display = 'none'
  rawTextFieldLabel.style.display = 'none'

  submitFileInstead.innerText = "Lets go back to raw text"

  submitFileField.style.display = 'block'
  usingFileInstead = true

submitButton.addEventListener 'click', ->
  handleSubmitEvent()

submitFileInstead.addEventListener 'click', ->
  handleFileSubmitting()


fileInput.addEventListener 'change', (event)->
  files = event.target.files

  if files.length is 0
    alert 'You must select a file to upload.'
    return

  extension = files[0].name.split('.').pop()

  unless extension in ['txt', 'md']
    alert "Beaufort only supports plain text (.txt) and Markdown (.md) files at this time."
    return

  try
    file = files[0]

    fileContents = await file.text()

    sessionStorage.setItem('input', fileContents)

    if extension is 'md'
      sessionStorage.setItem('input-is-markdown', 'true')

    window.location.href='output.html'

  catch error
    alert 'There was an error reading the file.'

seeMoreOptionsButton.addEventListener 'click', ->
  if moreOptionsDiv.style.display is 'block'
    seeMoreOptionsButton.style.marginBottom = '0px'
    moreOptionsDiv.style.display = 'none'
  else
    seeMoreOptionsButton.style.marginBottom = '30px'
    moreOptionsDiv.style.display = 'block'

  if moreOptionsDiv.style.display is 'block'
    seeMoreOptionsButton.innerText = 'See less options'
  else
    seeMoreOptionsButton.innerText = 'See more options'


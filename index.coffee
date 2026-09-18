
submitButton = document.getElementById('submit')

rawTextField = document.getElementById('input')

submitFileInstead = document.getElementById('input-file-instead')

submitFileField = document.getElementById('file-input-container')

rawTextFieldLabel = document.getElementById('raw-input-label')

fileInput = document.getElementById('file-input')

# submitting a file instead of pasting text
usingFileInstead = false

handleSubmitEvent = ->
  if rawTextField.value.length is 0
    alert 'Your input is empty.'
    return

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

  if extension isnt 'txt'
    alert "Beaufort only supports .txt files at this time."
    return

  try
    file = files[0]

    fileContents = await file.text()

    sessionStorage.setItem('input', fileContents)

    window.location.href='output.html'

  catch error
    alert 'There was an error reading the file.'
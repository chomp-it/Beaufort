
# submitting a file instead of pasting text
usingFileInstead = false

$ = (id) -> document.getElementById id

alert_return = (message) ->
  alert message
  return

hide = (element) -> element.style.display = 'none'
display = (element) -> element.style.display = 'block'

# check for a match against any possible checks
thisCanBeParsed = (text) ->
  if text.match(/\b(([A-Z]+){2,})\b/) or text.match(/_([^_]+)_/) or text.match(/\*\*([^*]+)\*\*/)
    return true
  else
    return false

handleSubmitEvent = ->
  if $('input').value.length is 0
    alert 'Your input is empty.'
    return

  unless thisCanBeParsed $('input').value
    unless $('generate-flashcards').checked
      alert_return "This input will not generate any flashcards."
      return

  # this conditional and the next just prevent the user from choosing conflicting options
  if $('generate-flashcards').checked and $('use-capitalization-for-answers').checked
    alert_return 'You cannot use capitalization for answers when generating flashcards.'

  if $('use-markdown').checked and ($('generate-flashcards').checked or $('use-capitalization-for-answers').checked)
    alert_return 'You have conflicting options selected.'

  gf_value = if $('generate-flashcards').checked then true else false
  sessionStorage.setItem('generate-flashcards', gf_value)

  uc_value = if $('use-capitalization-for-answers').checked then true else false
  sessionStorage.setItem('use-capitalization-for-answers', uc_value)

  console.log "use markdown: #{$('use-markdown').checked}"

  um_value = if $('use-markdown').checked then true else false
  sessionStorage.setItem('use-markdown', um_value)


  sessionStorage.setItem('input', $('input').value)

  sessionStorage.setItem('input-is-markdown', 'false')

  window.location.href = 'output.html'

handleFileSubmitting = ->
  if usingFileInstead
    display $('input')
    display $('submit')
    display $('raw-input-label')

    $('input-file-instead').innerText = "Actually, I want to use a file instead"

    hide $('file-input-container')

    usingFileInstead = no
    return

  hide $('input')
  hide $('submit')
  hide $('raw-input-label')

  $('input-file-instead').innerText = "Lets go back to raw text"

  display $('file-input-container')
  usingFileInstead = yes

$('submit').addEventListener 'click', ->
  handleSubmitEvent()

$('input-file-instead').addEventListener 'click', ->
  handleFileSubmitting()

submitImageFile = (formData) ->
  fetch("/upload", {
    method: "POST",
    body: formData
  }).then (response) ->
    response.json()
      .then (data) ->
        localStorage.setItem('input', data)
        window.location.href='output.html'

$('file-input').addEventListener 'change', (event)->
  files = event.target.files

  if files.length is 0 then alert_return 'You must select a file to upload.'

  extension = files[0].name.split('.').pop()

  if extension in ['jpeg', 'jpg', 'png']
    formData = new FormData()
    formData.append("image", $('file-input').files[0])
    submitImageFile formData

  unless extension in ['txt', 'md']
    alert_return "Beaufort only supports plain text (.txt) and Markdown (.md) files at this time."

  try
    file = files[0]

    fileContents = await file.text()

    if thisCanBeParsed fileContents is false
      alert_return "This file will not generate any flashcards."

    sessionStorage.setItem('input', fileContents)

    iis_value = if extension is 'md' then true else false
    sessionStorage.setItem('input-is-markdown', iis_value)

    window.location.href='output.html'

  catch error
    alert 'There was an error reading the file.'

$('see-more-options').addEventListener 'click', ->
  if $('other-options').style.display is 'block'
    $('see-more-options').style.marginBottom = '0px'
    hide $('other-options')
  else
    $('see-more-options').style.marginBottom = '30px'
    display $('other-options')

  if $('other-options').style.display is 'block'
    $('see-more-options').innerText = 'See less options'
  else
    $('see-more-options').innerText = 'See more options'


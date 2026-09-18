
submitButton = document.getElementById('submit')

rawTextField = document.getElementById('input')

handleSubmitEvent = ->
  if rawTextField.value.length is 0
    alert 'Your input is empty.'
    return

  sessionStorage.setItem('input', rawTextField.value)

  window.location.href='output.html'

submitButton.addEventListener 'click', ->
  handleSubmitEvent()
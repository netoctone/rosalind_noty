$ ->
  $('[data-cookie]').each ->
    cookieEl = $(@)

    cookieEl.append(inputsEl = $('<div/>'))
    inputsEl.delegate '[data-remove]', 'click', ->
      $(@).closest('[data-cookie-input]').remove()

    cookieEl.append(controlsEl = $('<div/>'))

    for key, val of cookieEl.data('cookie')
      inputsEl.append $(JST['views/cookie_input'](key: key, value: val))

    controlsEl.delegate '[data-add]', 'click', ->
      inputsEl.append $(JST['views/cookie_input']({}))

    controlsEl.delegate '[data-submit]', 'click', ->
      hash = {}
      inputsEl.find('[data-cookie-input]').each ->
        inputEl = $(@)
        hash[inputEl.find('[data-key]').val()] = inputEl.find('[data-val]').val()

      $.ajax
        data: { cookies: hash }
        dataType: 'json'
        type: 'post'
        url: 'cookie'
        success: ->
          alert('done')
        error:
          alert('failed')

    controlsEl.append $("<button class='btn' data-add='true'>Add</button>")
    controlsEl.append $("<button class='btn btn-success' data-submit='true'>Submit</button>")

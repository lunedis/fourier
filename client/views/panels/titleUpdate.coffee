Template.titleUpdate.events
  'submit .titleUpdate': (event) ->
    console.log 'update'
    event.preventDefault()
    title = event.target.title.value
    Panels.update @_id, 
      $set: 
        'title': title
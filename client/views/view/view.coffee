Template['view'].helpers
	doctrineName: ->
    Doctrines.findOne(_id: @doctrine).name
  panels: ->
    Panels.find view: @_id
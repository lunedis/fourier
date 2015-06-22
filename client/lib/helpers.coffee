UI.registerHelper 'formatNumber', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
     
    context.toFixed(decimals).replace /\d(?=(\d{3})+$)/g, '$&,'

UI.registerHelper 'formatNumberK', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    (context / 1000).toFixed(decimals)
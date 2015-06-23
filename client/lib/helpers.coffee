@formatNumber = (number, decimals = 0) ->
  number.toFixed(decimals).replace /\d(?=(\d{3})+$)/g, '$&,'

UI.registerHelper 'formatNumber', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    formatNumber(context, decimals)

UI.registerHelper 'noDecimals', (context, options) ->
  if context
    context.toFixed(0)

UI.registerHelper 'formatNumberK', (context, options) ->
  if context
    decimals = 0
    if typeof options == 'number'
      decimals = options
    
    (context / 1000).toFixed(decimals)

UI.registerHelper 'log', (context, options) ->
  console.log @
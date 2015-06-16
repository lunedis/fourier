Template.application.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    $('#dmgApplication').highcharts
      chart:
        type: 'spline'
      title:
        text:
          ''
      plotOptions:
        series:
          animation: false
        spline:
          marker:
            enabled: false
      yAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,120), (distance) ->
            Desc.dps ship.stats.damage, panelData.targetNavigation, distance * 1e3
        }

Template.application.events
  'submit #update': (event) ->
    event.preventDefault()
    speed = event.target.speed.value
    sig =  event.target.sig.value
    Panels.update @_id, 
      $set: 
        'data.targetNavigation.speed': speed
        'data.targetNavigation.sig': sig
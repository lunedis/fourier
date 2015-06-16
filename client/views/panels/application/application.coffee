Template.application.rendered = ->
  this.autorun ->
    panelData = Template.currentData().data
    fittings = Fittings.find({_id: {$in: panelData.fittings}}).fetch()

    navigation = Desc.applyEwar panelData.targetNavigation, panelData.webs, panelData.tps

    maxDPS = _.max (fit.stats.damage.total for fit in fittings)

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
      tooltip:
        crosshairs: true,
        valueDecimals: 0,
        headerFormat: '<span>{point.key}k:</span><br/>'
      yAxis:
        min: 0
        max: maxDPS
      xAxis:
        min: 0
      series: _.map fittings, (ship) ->
        return {
          name: ship.shipTypeName
          data: _.map _.range(0,120), (distance) ->
            Desc.dps ship.stats.damage, navigation, distance * 1e3
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

  'click .plusEwar': (event) ->
    update = {$push: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$push[target] = event.target.getAttribute 'data-value'
    Panels.update @_id, update

  'click .minusEwar': (event) ->
    update = {$pop: {}}
    target = 'data.' + event.target.getAttribute 'data-target'
    update.$pop[target] = 1
    Panels.update @_id, update  
